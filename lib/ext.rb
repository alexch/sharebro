class Module
  # Encapsulates the common pattern of:
  #
  #   alias_method :foo_without_feature, :foo
  #   alias_method :foo, :foo_with_feature
  #
  # With this, you simply do:
  #
  #   alias_method_chain :foo, :feature
  #
  # And both aliases are set up for you.
  #
  # Query and bang methods (foo?, foo!) keep the same punctuation:
  #
  #   alias_method_chain :foo?, :feature
  #
  # is equivalent to
  #
  #   alias_method :foo_without_feature?, :foo?
  #   alias_method :foo?, :foo_with_feature?
  #
  # so you can safely chain foo, foo?, and foo! with the same feature.
  def alias_method_chain(target, feature)
    # Strip out punctuation on predicates or bang methods since
    # e.g. target?_without_feature is not a valid method name.
    aliased_target, punctuation = target.to_s.sub(/([?!=])$/, ''), $1
    yield(aliased_target, punctuation) if block_given?

    with_method, without_method = "#{aliased_target}_with_#{feature}#{punctuation}", "#{aliased_target}_without_#{feature}#{punctuation}"

    alias_method without_method, target
    alias_method target, with_method

    case
      when public_method_defined?(without_method)
        public target
      when protected_method_defined?(without_method)
        protected target
      when private_method_defined?(without_method)
        private target
    end
  end
end

# http://grosser.it/2009/10/15/descriptive-raise-tired-of-exception-classobject-expected/
# descriptive raise
# normal: raise 1 == TypeError: exception class/object expected
# now: raise 1 == RuntimeError: 1
class Object
  def raise_with_helpfulness(*args)
    raise_without_helpfulness(*args)
  rescue TypeError => e
    raise_without_helpfulness args.first.inspect if ['exception class/object expected', 'exception object expected'].include?(e.to_s)
    raise_without_helpfulness e
  end
  alias_method_chain :raise, :helpfulness
end


class String
  def truncated_to(max_length = 20, ellipsis = "...")
    if length > max_length
      self[0..(max_length - ellipsis.length)] + ellipsis
    else
      self
    end
  end
  
  def snake_case
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end

  # stolen from activesupport
  #  https://github.com/rails/rails/blob/91c18554f6f54ae2d4cb7e945d830b75aa0c3b18/activesupport/lib/active_support/inflector/methods.rb#L87
  
  # Ruby 1.9 introduces an inherit argument for Module#const_get and
  # #const_defined? and changes their default behavior.
  if Module.method(:const_get).arity == 1
    # Tries to find a constant with the name specified in the argument string:
    #
    #   "Module".constantize     # => Module
    #   "Test::Unit".constantize # => Test::Unit
    #
    # The name is assumed to be the one of a top-level constant, no matter whether
    # it starts with "::" or not. No lexical context is taken into account:
    #
    #   C = 'outside'
    #   module M
    #     C = 'inside'
    #     C               # => 'inside'
    #     "C".constantize # => 'outside', same as ::C
    #   end
    #
    # NameError is raised when the name is not in CamelCase or the constant is
    # unknown.
    def constantize
      camel_cased_word = self
      names = camel_cased_word.split('::')
      names.shift if names.empty? || names.first.empty?

      constant = Object
      names.each do |name|
        constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
      end
      constant
    end
  else
    def constantize #:nodoc:
      camel_cased_word = self
      names = camel_cased_word.split('::')
      names.shift if names.empty? || names.first.empty?

      constant = Object
      names.each do |name|
        constant = constant.const_defined?(name, false) ? constant.const_get(name) : constant.const_missing(name)
      end
      constant
    end
  end

end

class Hash
  alias :<< :merge

  def pluck *keys
    select do |key, value|
      (keys.include? key) || (keys.include? key.to_sym) || (keys.include? key.to_s)
    end
  end
end

require 'time'
require 'date'
class Time
  # UTC and ISO8601 with 3 decimals using Z
  def universal
    dup.utc.to_datetime.iso8601(3).gsub(/\+00:00/, "Z")
  end
end

#############

# Taken from RAILS, see RAIL'S LICENSE for usage

# This class has dubious semantics and we only have it so that
# people can write params[:key] instead of params['key']
# and they get the same value for both keys.
unless defined?(HashWithIndifferentAccess)
  class Hash
    def with_indifferent_access
      hash = HashWithIndifferentAccess.new(self)
      hash.default = self.default
      hash
    end
  end

  class HashWithIndifferentAccess < Hash
    def initialize(constructor = {})
      if constructor.is_a?(Hash)
        super()
        update(constructor)
      else
        super(constructor)
      end
    end

    def default(key = nil)
      if key.is_a?(Symbol) && include?(key = key.to_s)
        self[key]
      else
        super
      end
    end

    alias_method :regular_writer, :[]= unless method_defined?(:regular_writer)
    alias_method :regular_update, :update unless method_defined?(:regular_update)

    # Assigns a new value to the hash:
    #
    #   hash = HashWithIndifferentAccess.new
    #   hash[:key] = "value"
    #
    def []=(key, value)
      regular_writer(convert_key(key), convert_value(value))
    end

    # Updates the instantized hash with values from the second:
    #
    #   hash_1 = HashWithIndifferentAccess.new
    #   hash_1[:key] = "value"
    #
    #   hash_2 = HashWithIndifferentAccess.new
    #   hash_2[:key] = "New Value!"
    #
    #   hash_1.update(hash_2) # => {"key"=>"New Value!"}
    #
    def update(other_hash)
      other_hash.each_pair { |key, value| regular_writer(convert_key(key), convert_value(value)) }
      self
    end

    alias_method :merge!, :update

    # Checks the hash for a key matching the argument passed in:
    #
    #   hash = HashWithIndifferentAccess.new
    #   hash["key"] = "value"
    #   hash.key? :key  # => true
    #   hash.key? "key" # => true
    #
    def key?(key)
      super(convert_key(key))
    end

    alias_method :include?, :key?
    alias_method :has_key?, :key?
    alias_method :member?, :key?

    # Fetches the value for the specified key, same as doing hash[key]
    def fetch(key, *extras)
      super(convert_key(key), *extras)
    end

    # Returns an array of the values at the specified indices:
    #
    #   hash = HashWithIndifferentAccess.new
    #   hash[:a] = "x"
    #   hash[:b] = "y"
    #   hash.values_at("a", "b") # => ["x", "y"]
    #
    def values_at(*indices)
      indices.collect {|key| self[convert_key(key)]}
    end

    # Returns an exact copy of the hash.
    def dup
      HashWithIndifferentAccess.new(self)
    end

    # Merges the instantized and the specified hashes together, giving precedence to the values from the second hash
    # Does not overwrite the existing hash.
    def merge(hash)
      self.dup.update(hash)
    end

    # Performs the opposite of merge, with the keys and values from the first hash taking precedence over the second.
    # This overloaded definition prevents returning a regular hash, if reverse_merge is called on a HashWithDifferentAccess.
    def reverse_merge(other_hash)
      super other_hash.with_indifferent_access
    end

    # Removes a specified key from the hash.
    def delete(key)
      super(convert_key(key))
    end

    def stringify_keys!; self end
    def symbolize_keys!; self end
    def to_options!; self end

    # Convert to a Hash with String keys.
    def to_hash
      Hash.new(default).merge(self)
    end

    protected
      def convert_key(key)
        key.kind_of?(Symbol) ? key.to_s : key
      end

      def convert_value(value)
        case value
        when Hash
          value.with_indifferent_access
        when Array
          value.collect { |e| e.is_a?(Hash) ? e.with_indifferent_access : e }
        else
          value
        end
      end
  end
end

Mash = HashWithIndifferentAccess unless defined?(Mash)


