// from https://bitbucket.org/keakon/reader-sharer/src/0ea31e16de92/contentscript.js

(function() {
	var $document = $(document);

	var match = /{id:\"display-lang\",\s?value:\"([^\"]+)\"}/.exec($('script').last().text());
	if (match) {
		var lang = match[1];
	} else {
		lang = 'en';
	}

	if (lang == 'zh-CN') {
		var shared_text = 'å…±äº«æ¡ç›®';
		var notes_text = 'å¤‡æ³¨';
		var share_text = 'å…±äº«';
		var share_note_text = 'å…±äº«å¤‡æ³¨';
		var like_text = 'å–œæ¬¢';
		var liked_text = 'æ‚¨å–œæ¬¢çš„æ¡ç›®';
		var add_share_text = 'æ·»åŠ åˆ°å…±äº«æ¡ç›®';
		var post_text = 'å‘å¸ƒå¤‡æ³¨';
		var posting_text = 'å‘å¸ƒå¤‡æ³¨ä¸­â€¦';
		var close_text = 'å…³é—­';
	} else if (lang == 'zh-TW' || lang == 'zh-HK') {
		shared_text = 'å…±äº«æ¢ç›®';
		notes_text = 'å‚™è¨»';
		share_text = 'å…±äº«';
		share_note_text = 'å…±äº«å‚™è¨»';
		like_text = 'å–œæ­¡';
		liked_text = 'æ‚¨å–œæ­¡çš„æ¢ç›®';
		add_share_text = 'æ·»åŠ åˆ°å…±äº«æ¢ç›®';
		post_text = 'ç™¼ä½ˆå‚™è¨»';
		posting_text = 'ç™¼ä½ˆå‚™è¨»ä¸­â€¦';
		close_text = 'é—œé–‰';
	} else {
		shared_text = 'Your shared items';
		notes_text = 'Notes';
		share_text = 'Share';
		share_note_text = 'Share with note';
		like_text = 'Like';
		liked_text = 'Your liked items';
		add_share_text = 'Add to shared items';
		post_text = 'Post item';
		posting_text = 'Posting itemâ€¦';
		close_text = 'Close';
	}

	var url = document.URL;

	var $shared = $('<div id="shared-selector" class="selector"><a href="#stream/user/-/state/com.google/broadcast" class="link"><div class="selector-icon"></div><span class="text">' + shared_text + '</span></a></div>');
	$shared.insertAfter('#star-selector').click(function() {
		$shared.addClass('selected');
	});

	var $notes = $('<div id="notes-selector" class="selector"><a href="#stream/user/-/state/com.google/created" class="link"><div class="selector-icon"></div><span class="text">' + notes_text + '</span></a></div>');
	$notes.insertAfter($shared).click(function() {
		$notes.addClass('selected');
	});

	var $liked = $('<div id="like-selector" class="selector"><a href="#stream/user/-/state/com.google/like" class="link"><div class="selector-icon"></div><span class="text">' + liked_text + '</span></a></div>');
	$liked.insertAfter($notes).click(function() {
		$liked.addClass('selected');
	});

	if (/broadcast(?!-friends)/.exec(url)) {
		$shared.addClass('selected');
	} else if (/created/.exec(url)) {
		$notes.addClass('selected');
	} else if (/like/.exec(url)) {
		$liked.addClass('selected');
	}

	$('#scrollable-sections .selector, #lhn-recommendations, #lhn-subscriptions').click(function() {
		if (this.id != 'shared-selector') {
			$shared.removeClass('selected');
		}
		if (this.id != 'notes-selector') {
			$notes.removeClass('selected');
		}
		if (this.id != 'like-selector') {
			$liked.removeClass('selected');
		}
	});

	var unsafeWindow = window.unsafeWindow;
	if (!unsafeWindow) {
		var div = document.createElement('div');
		div.setAttribute('onclick', 'return window;');
		unsafeWindow = div.onclick();
	}

	var user_id = unsafeWindow._USER_ID;

	var data = null;
	var key, key2, state_key, state_key2;
	var key3 = 'jf';
	var token_key = null;

	function check(event) {
		var which = event.which;
		if (event.shiftKey && !event.ctrlKey && !event.altKey && !event.metaKey) {
			if (which == 70 || which == 102) {			// Shift + F
				edit_item('share');
			} else if (which == 68 || which == 100) {	// Shift + D
				show_note_dialog();
				return false;
			}
		} else if (!event.shiftKey && !event.ctrlKey && !event.altKey && !event.metaKey) {
			if (which == 108 || which == 76) {	// L
				edit_item('like');
			} else if (
				which == 13 ||					// Enter
				which == 32 ||					// Space
				which == 111 || which == 79 ||	// O
				which == 110 || which == 78 ||	// N
				which == 112 || which == 80 ||	// P
				which == 106 || which == 74 ||	// J
				which == 107 || which == 75		// K
			) {
				setTimeout(show_button, 0);
			}
		}

	}

	function scroll_check() {
		setTimeout(function () {
			if ($('#current-entry').has($share_button).length == 0) {
				show_button();
			}
		}, 100);
	}

	function get_current_item() {
		try {
			var current_entry = document.getElementById('current-entry');
			if (!current_entry) {
				return null;
			}
			var className = current_entry.className;
			var match = /entry-(\d+)/.exec(className);
			var index = parseInt(match[1]);
			return data[key2][key3][index];
		} catch (e) {
			return null;
		}
	}

	var $like_button = $('<span class="like"><span class="link unselectable">' + like_text + '</span></span>');
	var $share_button = $('<span class="broadcast"><span class="link unselectable">' + share_text + '</span></span>');
	var $share_note_button = $('<span class="broadcast-with-note"><span class="link unselectable">' + share_note_text + '</span></span>');
	function show_button() {
		if (data === null) {
			find_data:
			for (key in unsafeWindow) {
				if (key.length == 2) {
					var obj = unsafeWindow[key];
					if (obj && typeof(obj) == 'object' && !('length' in obj)) {
						for (key2 in obj) {
							if (key2.length == 2) {
								var obj2 = obj[key2];
								if (obj2 && typeof(obj2) == 'object' && !('length' in obj2) && key3 in obj2) {
									var obj3 = obj2[key3];
									if (obj3 && typeof(obj3) == 'object' && 'length' in obj3) {
										data = obj;
										break find_data;
									}
								}
							}
						}
					}
				}
			}

			if (data === null || data[key2][key3].length == 0) {
				$entries.off('click', '.collapsed', show_button);
				$('#viewer-entries-container').off('scroll', scroll_check);
				$document.off('keypress', check);
				$expanded_view_button.off('click', click_expanded_view_button);
				$list_view_button.off('click', click_list_view_button);
				return;
			}

			var item = data[key2][key3][0];
			for (key in item) {
				var value = item[key];
				if (!value) {
					continue;
				}
				if (!token_key && typeof(value) == 'string' && value.substring(0, 32) == 'tag:google.com,2005:reader/item/') {
					token_key = key;
				}
				if (!state_key && typeof(value) == 'object' && value.length) {
					find_state_key:
					for (var i = 0; i < value.length; ++i) {
						var value2 = value[i];
						if (value2 && typeof(value) == 'object' && value2.type == 'state') {
							state_key = key;
							for (state_key2 in value2) {
								var value3 = value2[state_key2];
								if (value3 && typeof(value3) == 'object' && 'length' in value3) {
									break find_state_key;
								}
							}
						}
					}
				}
				if (token_key && state_key) {
					break;
				}
			}
		}

		item = get_current_item();
		if (!item) {
			return;
		}

		$like_button.detach().removeClass('liked');
		$share_button.detach().removeClass('shared');

		if (item.liked) {
			$like_button.addClass('liked');
		}
		if (item.shared) {
			$share_button.addClass('shared');
		}
		if (item.shared === undefined) {
			item.shared = false;
			var states = item[state_key];
			for (i = 0; i < states.length; ++i) {
				var state = states[i];
				if (state.userId == user_id) {
					var state_key3 = state[state_key2][1];
					if (state_key3 == 'like') {
						$like_button.addClass('liked');
						item.liked = true;
					}
					if (state_key3 == 'broadcast') {
						$share_button.addClass('shared');
						item.shared = true;
					}
					if (item.liked && item.shared) {
						break;
					}
				}
			}
		}
		$like_button.insertAfter('#current-entry .item-plusone');
		$share_button.insertAfter($like_button);
		$share_note_button.insertAfter($share_button);
	}
	var $entries = $('#entries').on('click', '.collapsed', show_button);

	function edit_item(state) {
		var change_like = state == 'like';

		try {
			var item = get_current_item();
			if (!item) {
				return;
			}
			var feed_link = decodeURIComponent($('#current-entry a.entry-source-title').attr('href').substring(13));
			var post_data = {
				T: unsafeWindow._COMMAND_TOKEN,
				i: item[token_key],
				async: true,
				s: feed_link
			};
			if (change_like) {
				post_data[item.liked ? 'r' : 'a'] = 'user/-/state/com.google/like';
				var toggle = function() {
					item.liked = !item.liked;
					$like_button.toggleClass('liked');
				}
			} else {
				post_data[item.shared ? 'r' : 'a'] = 'user/-/state/com.google/broadcast';
				toggle = function() {
					item.shared = !item.shared;
					$share_button.toggleClass('shared');
				}
			}

			$.ajax({
				type: 'POST',
				url: '/reader/api/0/edit-tag?client=scroll',
				data: post_data,
				error: toggle
			});
			toggle();
		} catch (e) {
		}
	}

	function add_note(options) {
		var post_data = {
			T: unsafeWindow._COMMAND_TOKEN,
			linkify: false,
			share: options.share
		};
		if (options.content) {
			post_data.snippet = options.content;
			post_data.annotation = options.note;
		} else {
			post_data.snippet = options.note;
		}
		if (options.title) {
			post_data.title = options.title;
		}
		if (options.url) {
			post_data.url = options.url;
		}
		if (options.srcTitle) {
			post_data.srcTitle = options.srcTitle;
		}
		if (options.srcUrl) {
			post_data.srcUrl = options.srcUrl;
		}
		ajax_options = {
			type: 'POST',
			url: '/reader/api/0/item/edit?client=scroll',
			data: post_data
		};
		if (options.success) {
			ajax_options.success = options.success;
		}
		if (options.error) {
			ajax_options.error = options.error;
		}
		$.ajax(ajax_options);
	}

	var posting_note = false;
	function post_note() {
		if (posting_note) {
			return;
		}
		posting_note = true;
		$post_button.text(posting_text);
		var options = {
			share: should_share_checkbox.checked,
			note: $note_content.val(),
			success: function() {
				posting_note = false;
				$dialog_background.hide();
				$note_dialog.hide();
			},
			error: function() {
				$post_button.text(post_text);
				posting_note = false;
			}
		}
		try {
			var item = get_current_item();
			if (item) {
				options.title = item.g;
				options.content = item.zd;
				options.url = item.Rd.alternate[0].rf;
				options.srcTitle = item.gc.g;
				options.srcUrl = item.gc.c.streamId.substring(5);
			}
			add_note(options);
		} catch (e) {
			$post_button.text(post_text);
			posting_note = false;
		}
	}

	function show_note_dialog() {
		$note_content.val('');
		$post_button.text(post_text);
		should_share_checkbox.checked = true;
		$dialog_background.show();
		$note_dialog.center().show();
		$note_content.select();
	}

	var $dialog_background = $('<div class="fr-modal-dialog-bg"></div>').hide().appendTo('body');
	var $note_dialog = $('<div class="fr-modal-dialog"><div class="fr-modal-dialog-content"><textarea class="note-content"></textarea></div><div class="fr-modal-dialog-buttons"><input type="checkbox" id="should-share"/><label for="should-share">' + add_share_text + '</label><button name="ok" class="goog-buttonset-default">' + post_text + '</button><button name="cancel">' + close_text + '</button></div></div>').hide().appendTo('body');
	var $note_content = $note_dialog.find('textarea.note-content');
	var $post_button = $note_dialog.find('button[name=ok]').click(post_note);
	var $close_button = $note_dialog.find('button[name=cancel]').click(function() {
		$dialog_background.hide();
		$note_dialog.hide();
	});
	var should_share_checkbox = $note_dialog.find('#should-share')[0];

	jQuery.fn.center = function() {
		return this.css({
			'top': '50%',
			'left': '50%',
			'margin': '-' + (this.height() / 2) + 'px 0 0 -' + (this.width() / 2) + 'px'
		});
	}

	$like_button.on('click', function() {
		edit_item('like');
	});
	$share_button.on('click', function() {
		edit_item('share');
	});
	$share_note_button.click(show_note_dialog);
	$document.keypress(check);

	var $view_buttons = $('#stream-view-options-container>div');
	var $expanded_view_button = $view_buttons.eq(1);
	var $list_view_button = $view_buttons.eq(2);
	if ($expanded_view_button.hasClass('jfk-button-checked')) {
		var is_expanded_view = true;
		$('#viewer-entries-container').scroll(scroll_check);
	} else {
		is_expanded_view = false;
	}

	function click_expanded_view_button() {
		if (!is_expanded_view) {
			is_expanded_view = true;
			$('#viewer-entries-container').scroll(scroll_check);
		}
	};

	function click_list_view_button() {
		if (is_expanded_view) {
			is_expanded_view = false;
			$('#viewer-entries-container').off('scroll', scroll_check);
		}
	};

	$expanded_view_button.click(click_expanded_view_button);
	$list_view_button.click(click_list_view_button);
})();