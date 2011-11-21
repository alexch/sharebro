require "ext"
require "logs"

# say is a logging system that outputs to stdout
# and to a logging couchdb
module Say
  def say msg, extra = {}
    now = Time.now
    text = msg.is_a?(String) ? msg : PP.pp(msg, "")
    print "#{now} - #{text}\n"  # puts is not thread-buffer-safe
    Logs.put({
      type: 'log',
      at: now.universal,
      message: text,
    }.merge(extra))
  end

  def say_error e, details = nil, extra = {}
    options = {:error => true}.merge(extra)
    if e.is_a? Exception
      msg = "#{e.class}: #{e.message}#{" - #{details}" if details} - #{e.backtrace[0..2].join('|')}"
      options[:backtrace] = e.backtrace
    else
      msg = msg.to_s
    end
    say msg, options
  end
end
