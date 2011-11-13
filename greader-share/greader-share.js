
/*
 *  i know the code could be much nicer.
 *  Right now it's more a proof of concept.
 *  please don't judge me too hard, my first goal was to bring this as fast as possible. 
 *  I'll clean. promise. hey, why don't you help to code this thing ? 
 *  so gReader user don't settle and go for G+ and forget about it.
 *  I have nothing against G+, but an open and standard way should exist as well.
 * 
 */

if(typeof unsafeWindow !="undefined"){
	var d = unsafeWindow.document;
}else{
	var d = document;
}


/* library */


function strip_tags (input, allowed) {
    // http://kevin.vanzonneveld.net
    // +   original by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +   improved by: Luke Godfrey
    // +      input by: Pul
    // +   bugfixed by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +   bugfixed by: Onno Marsman
    // +      input by: Alex
    // +   bugfixed by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +      input by: Marc Palau
    // +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +      input by: Brett Zamir (http://brett-zamir.me)
    // +   bugfixed by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +   bugfixed by: Eric Nagel
    // +      input by: Bobby Drake
    // +   bugfixed by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // +   bugfixed by: Tomasz Wesolowski
    // +      input by: Evertjan Garretsen
    // +    revised by: Rafał Kukawski (http://blog.kukawski.pl/)
    // *     example 1: strip_tags('<p>Kevin</p> <br /><b>van</b> <i>Zonneveld</i>', '<i><b>');
    // *     returns 1: 'Kevin <b>van</b> <i>Zonneveld</i>'
    // *     example 2: strip_tags('<p>Kevin <img src="someimage.png" onmouseover="someFunction()">van <i>Zonneveld</i></p>', '<p>');
    // *     returns 2: '<p>Kevin van Zonneveld</p>'
    // *     example 3: strip_tags("<a href='http://kevin.vanzonneveld.net'>Kevin van Zonneveld</a>", "<a>");
    // *     returns 3: '<a href='http://kevin.vanzonneveld.net'>Kevin van Zonneveld</a>'
    // *     example 4: strip_tags('1 < 5 5 > 1');
    // *     returns 4: '1 < 5 5 > 1'
    // *     example 5: strip_tags('1 <br/> 1');
    // *     returns 5: '1  1'
    // *     example 6: strip_tags('1 <br/> 1', '<br>');
    // *     returns 6: '1  1'
    // *     example 7: strip_tags('1 <br/> 1', '<br><br/>');
    // *     returns 7: '1 <br/> 1'
    allowed = (((allowed || "") + "").toLowerCase().match(/<[a-z][a-z0-9]*>/g) || []).join(''); // making sure the allowed arg is a string containing only tags in lowercase (<a><b><c>)
    var tags = /<\/?([a-z][a-z0-9]*)\b[^>]*>/gi,
        commentsAndPhpTags = /<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi;
    return input.replace(commentsAndPhpTags, '').replace(tags, function ($0, $1) {
        return allowed.indexOf('<' + $1.toLowerCase() + '>') > -1 ? $0 : '';
    });
}



function getByClass(p,tag,clas){
	var hs = p.getElementsByTagName(tag);
	var j = hs.length;
	for(var i=0;i<j;i++){
		if(hs[i].className==clas){
			return hs[i];
			break;
		}
	}
	return false;
}

function insertScript(url){
	var ss = d.createElement('script');
	ss.src = url;
	d.body.appendChild(ss);
}





function lipsAddClass(el,newClass){
	var classes = el.className.split(' ');
	for(var i=0,j=classes.length;i<j;i++){
		if(classes[i]==newClass) return;
	}
	classes.push(newClass);
	el.className = classes.join(' ');
}

function lipsRemoveClass(el, classToRemove){
	var classes = el.className.split(' ');
	var newClasses = [];
	for(var i=0,j=classes.length;i<j;i++){
		if(classes[i]!=classToRemove) newClasses.push();
	}
	el.className = newClasses.join(' ');
}





var LipsDialog = function(){
	
	/* public methods */
	
	//init the object. must be called right after instanciation
	this.init = function(){
		this.dialogType = 'Alert';// Alert | Confirm | Prompt
		this.promptInputType = 'Password';// Text | Password
		this.promptAllowEmpty = false;
		this.callbacks = null; // {onOK,onCancel}
		this.build();
		//this.registerEvents();
		
	};
	
	//an alert box. callbacks: onOk, onCancel (same event/button in this case)
	this.alert = function(text,callbacks){
		this.setDialogType('Alert');
		if(callbacks && typeof callbacks == 'object') this.callbacks = callbacks;
		this.setText(text);
		this.show();
	};
	
	//a confirm box. callbacks: onOK, onCancel
	this.confirm = function(text,callbacks){
		this.setDialogType('Confirm');
		if(callbacks && typeof callbacks == 'object') this.callbacks = callbacks;
		this.setText(text);
		this.show();
	};
	
	//a prompt box. callbacks: onOK, onCancel. when allowEmpty true, cliking cancel is allowed, but not OK if empty field (trimmed)
	this.prompt = function(text,callbacks,allowEmpty){
		this.promptAllowEmpty = allowEmpty || this.promptAllowEmpty;
		this.setDialogType('Prompt');
		if(callbacks && typeof callbacks == 'object') this.callbacks = callbacks;
		this.setText(text);
		this.show();
		this.inputEl.value = '';
	};
	
	
	
	/* private methods */
	
	this.build = function(){
		//build overlay
		this.overlayEl = d.createElement('div');
		this.overlayEl.id = 'lipsDialogOverlay';
		d.body.appendChild(this.overlayEl);
		
		//build box
		this.boxEl = d.createElement('div');
		this.boxEl.id = 'lipsDialogBox';
		this.boxEl.className = 'dialogTypeAlert';
		this.boxEl.innerHTML = '<div id="lipsDialogText">Hello, nothing to notify !</div><div id="lipsDialogInputWrap"><input type="'+this.promptInputType+'" id="lipsDialogInput" /></div><div id="lipsDialogButtonsWrap"><input type="button" id="lipsDialogButtonOK" value="OK" onclick="lipsDialog.actionOK();" /><input type="button" id="lipsDialogButtonCancel" class="cancelBtn" value="Cancel" onclick="lipsDialog.actionCancel();"/></div><b id="lipsDialogCloseButton" class="cancelBtn">x</b>';
		d.body.appendChild(this.boxEl);
		
		this.inputEl = d.getElementById('lipsDialogInput');
		this.buttonOKEl = d.getElementById('lipsDialogButtonOK');
		this.buttonCancelEl = d.getElementById('lipsDialogButtonCancel');
		this.textEl = d.getElementById('lipsDialogText');
	};
	
	this.registerEvents = function(){
		var self = this;
		window.addEventListener("keydown", this.keyDownHandler, false);
		/*
		this.buttonOKEl.onclick = function(e){
			alert('kjh');
			self.actionOK();
		};
		this.buttonCancelEl.addEventListener("click",function(e){ 
			self.actionCancel();
		}, false);
		*//*
		this.buttonOKEl.addEventListener('click',function(e){
			alert('kjh');
			self.actionOK();
		},true);
		*/
	};
	
	//this.keyDownHandler = function(){};
	
	this.actionOK = function(){
		if(this.dialogType=='prompt' && !this.promptAllowEmpty && this.inputEl.value.trim()==''){
			this.showNoEmptyMessage();
			return;
		}
		this.hide();
		if(this.callbacks && this.callbacks.onOK){
			if(this.dialogType=='Prompt') this.callbacks.onOK(this.inputEl.value);
			else this.callbacks.onOK();
		}
	};
	
	this.actionCancel = function(){
		if(this.callbacks && this.callbacks.onCancel) this.callbacks.onCancel();
		this.hide();
	};
	
	this.showNoEmptyMessage = function(){
		lipsAddClass(this.boxEl, 'emptyError')
	};
	
	this.show = function(){
		this.overlayEl.style.display = 'block';
		this.boxEl.style.display = 'block';
		if(this.dialogType=='Prompt'){
			this.inputEl.focus();
		}else{
			this.buttonOKEl.focus();
		}
	};
	
	this.hide = function(){
		this.overlayEl.style.display = 'none';
		this.boxEl.style.display = 'none';
	};
	
	
	this.setDialogType = function(newDialogType){
		if(this.dialogType==newDialogType) return;
		this.dialogType = newDialogType;
		this.resetBox();
	};
	
	this.resetBox = function(){
		this.textEl.innerHTML = '';
		this.inputEl.value = '';
		this.inputEl.setAttribute('type',this.promptInputType);
		lipsRemoveClass(this.boxEl,'dialogTypePrompt');
		lipsRemoveClass(this.boxEl,'dialogTypeAlert');
		lipsRemoveClass(this.boxEl,'dialogTypeConfirm');
		lipsRemoveClass(this.boxEl,'emptyError');
		lipsAddClass(this.boxEl, 'dialogType'+this.dialogType);
		
		this.callbacks = null;
	};
	
	this.setText = function(text){
		this.textEl.innerHTML = text;
	};
	
	//this.init();
	
	
	
};





var lipsDialog = new LipsDialog();
lipsDialog.init();



var lipscss = d.createElement('style');
lipscss.innerHTML = '#lipsFriendList{margin-left:42px}#lipsDialogOverlay{display:none;position:absolute;top:0;bottom:0;left:0;right:0;width:100%;height:100%;background:#000;z-index:1000;opacity:.2}#lipsDialogBox{display:none;position:absolute;top:50%;left:50%;width:500px;border:6px solid #c2cff1;background:#FFF;z-index:1010;margin-left:-250px}#lipsDialogBoxInner{display:none;position:relative}#lipsDialogText{padding:10px 7px 2px 7px}#lipsDialogButtonsWrap{padding:4px;text-align:right}#lipsDialogCloseButton{position:absolute;top:5px;right:4px;width:12px;height:12px;cursor:pointer;color:#AAA;display:none}#lipsDialogCloseButton:hover{color:#000}#lipsDialogInputWrap{padding:10px 7px 2px 7px;display:none}#lipsDialogInput{border:1px solid #858585;padding:2px 4px;width:70%}#lipsDialogInput:hover{border-color:#333}#lipsDialogInput .cancelBtn{display:none}#lipsDialogInput .emptyError .emptyErrorText{display:none}#lipsDialogBox.dialogTypeAlert .cancelBtn{display:none}#lipsDialogBox.dialogTypeConfirm .cancelBtn{display:inline}#lipsDialogBox.dialogTypePrompt #lipsDialogInputWrap{display:block}';
d.body.appendChild(lipscss);


var ss = d.createElement('script');
ss.src = 'http://lipsumarium.com/greader/md5.min.js';
d.body.appendChild(ss);


if(window._USER_EMAIL=='piremmanuel@gmail.com'){//testing before release.

	var lips_sharedItems = null;
	var lips_loadSharedItemsCallback = function(items){
		if(items && typeof items == 'array')
		lips_sharedItems = items;
	};
	var lips_itemIsShared = function(h){
		for(var i=0,j=lips_sharedItems;i<j;i++){
			if(h==lips_sharedItems[i].h){
				return true;
				break;
			}
		}
		return false;
	};
	
	insertScript('http://lipsumarium.com/greader/loadshareditems?_USER_ID='+encodeURIComponent(window._USER_ID)+'nc'+Math.random());
	
	var itemListWatchDog = function(){
		var c = d.getElementById("entries");
		if(!c) return;
		var entriesEls = getByClass(c,'div','entry');
		if(entriesEls.length==0) return;
		
		for(var i=0,j=entriesEls.length;i<j;i++){
			if(entriesEls[i].getAttribute('lips_sharedInit')!="1"){
				var e = entriesEls[i];
				var urlEl = getByClass(e,'a','entry-title-link');
				if(!urlEl) continue;
				var url = urlEl.href;
				
			}
		}
	};

}



//add "my shared items" link
var lipsmsiContainer = getByClass(d.getElementById('lhn-selectors'),'div','lhn-section-secondary');
var lipsmsiEl = document.createElement("div");
lipsmsiEl.id = 'lips-mySharedItems';
lipsmsiEl.className = 'selector no-icon';
lipsmsiEl.innerHTML = '<a href="#" class="link"><span class="text" id="lips-mySharedItems-btn">My shared items<sup style="color:red;">new!</sup></a>';

lipsmsiContainer.appendChild(lipsmsiEl);
d.getElementById('lips-mySharedItems-btn').addEventListener('click',function(e){
	window.location.href = 'http://www.google.com/reader/view/feed/http%3A%2F%2Flipsumarium.com%2Fgreader%2Ffeed%3F_USER_ID%3D'+window.encodeURIComponent(window._USER_ID);
},false);


var lipssmfEl = document.createElement("div");
lipssmfEl.id = 'lips-shareMyFeed';
lipssmfEl.className = 'selector no-icon';
lipssmfEl.innerHTML = '<a href="#" title="Share your public feed by email" class="lips-shareFeedByMail" id="lips-shareFeedByMail"><span class="text">Share my public feed<sup style="color:red;">new!</sup></span></a>';
lipsmsiContainer.appendChild(lipssmfEl);

var lips_shareFeedByMailEl = d.getElementById('lips-shareFeedByMail');
lips_shareFeedByMailEl.addEventListener('click',function(){
	lipsDialog.promptInputType = 'text';
	lipsDialog.prompt("<b>Share your feed with your followers !</b><br/>Enter emails here and we'll send them a link to your public feed.<br/>(multiple emails separated by comas)<br/><span style=\"font-size:10px;\">We don\'t collect emails.</span>",{
		onOK:function(emails){
			insertScript('http://lipsumarium.com/greader/sharemyfeed?_USER_ID='+window.encodeURIComponent(window._USER_ID)+'&emails='+window.encodeURIComponent(emails)+'&nc='+Math.random());
		}
	});
	
},false);


var topbar=d.getElementById('viewer-top-controls');
var shareBtn = d.createElement('div');
shareBtn.className = 'goog-inline-block jfk-button jfk-button-standard viewer-buttons';
shareBtn.id="share-button";
shareBtn.style.float="right";
shareBtn.style.cssFloat="right";
shareBtn.innerHTML = '<div class="goog-inline-block goog-flat-menu-button-caption">Share</div>';
shareBtn.addEventListener('click',doShare,false);
topbar.appendChild(shareBtn);

var waitEl = d.createElement('div');
waitEl.className = 'goog-inline-block';
waitEl.style.float="right";
shareBtn.style.cssFloat="right";
waitEl.style.display = 'none';
waitEl.innerHTML = '<div class="goog-inline-block"><img src="http://lipsumarium.com/greader/load.gif" /></div>';
topbar.appendChild(waitEl);



var fl_wrap = d.createElement('div');
fl_wrap.id = 'lipsFriendList';
d.getElementById('lhn-selectors').appendChild(fl_wrap);

var fl_sep = d.createElement('div');
fl_sep.className = 'selectors-footer';
d.getElementById('lhn-selectors').appendChild(fl_sep);

var fl_addWrap = d.createElement('div');
fl_addWrap.id = 'fl_addWrap';
fl_addWrap.innerHTML = '<input type="text" placeholder="Add friends by email" id="fl_addInput" /><a style="padding-top:2px;display:block;color:blue;text-decoration:underline;" href="http://sharebro.org" title="Help to promote open ways to share, tell your Reader friends about it." target="_blank">sharebro.org</a>';
fl_wrap.appendChild(fl_addWrap);



var shareURL='';
function doShare(){
	var e = d.getElementById('current-entry');
	if(!e){
		lipsDialog.alert('No item selected');
	}else{
		var aEl=getByClass(e,'a','entry-title-link');
		var a=null;
		if(aEl){
			a=aEl.href;
			t=aEl.innerHTML;
			
			var h2 = getByClass(e,'h2','entry-title');
			t = strip_tags(h2.innerHTML);
			
			
			var bEl = getByClass(e,'div','item-body');
			bo=bEl.innerHTML;
			
			var url = 'http://lipsumarium.com/greader/post?_USER_ID='+encodeURIComponent(window._USER_ID)+'&url='+encodeURIComponent(a)+'&title='+encodeURIComponent(t);
			if(url.length<1900){
				url+='&body='+encodeURIComponent(bo);
			}
			url = url.substring(0,1900);
			url+="&nc="+Math.random();
			shareURL=url;
			var ss = d.createElement('script');
			ss.src = url;
			lipsShowShareLoad();
			d.body.appendChild(ss);
			
		}else{
			lipsDialog.alert('Woops.. this should work! Are you sure you selected an item ? Please report bug to @lipsumar');
		}
		
		
		
	 
	}
}

var lips_addingFriendEmail = '';
var fl_addFormOnSubmit = function(e){
	if(e.keyCode==13){
		lips_addingFriendEmail = fl_addInput.value.trim();
		insertScript('http://lipsumarium.com/greader/addfriend?_USER_ID='+encodeURIComponent(window._USER_ID)+'&friend_USER_EMAIL='+encodeURIComponent(fl_addInput.value.trim())+"&nc="+Math.random());
		
	}
};

var fl_addInput = d.getElementById('fl_addInput');
fl_addInput.onkeydown = fl_addFormOnSubmit;


var lipsLoginCallback = function(){
	
	if(shareURL.trim()!=''){
		var ss = d.createElement('script');
		ss.src = shareURL;
		d.body.appendChild(ss);
	}
	
};


var addfeedUrl='';
var lips_addFriendCallBack = function(ok,friendEmail,friendID){
	fl_addInput.value = "";
	if(ok){
		lipsDialog.alert("Your friend\'s feed will be added to your feeds.<br/><br/>Put it in a folder named \"Friends\", and voila!\nNote that you have an option to rename the feed.");
		lips_addFeed('http://lipsumarium.com/greader/feed?_USER_ID='+friendID);
		
		/* not sure about this. see the discussion http://groups.google.com/group/sharebro/browse_thread/thread/4615be13216e03ee 
		lipsDialog.confirm("Let know "+friendEmail+" you just subscribed !<br/><br/>Do you want to send an email to "+friendEmail+" let him/her know ?",{
			onOK:function(){
				
			}
		});
		*/
		
		
		
	}else{
		lipsDialog.confirm("It seems your friend "+friendEmail+" is not yet using this plugin.\n\nDo you want us to send a mail to your friend to warn him about this script ? (no spam, promise)",{
			onOK:function(){
				insertScript('http://lipsumarium.com/greader/sendfriendrequest?friend_USER_EMAIL='+encodeURIComponent(lips_addingFriendEmail)+"&_USER_ID="+encodeURIComponent(window._USER_ID)+"&nc="+Math.random());
			}
		});
		
	}
};

var lips_addFeed = function(feedUrl){
	addfeedUrl = feedUrl;
	
	
	var e = d.createEvent("MouseEvent");
	e.initMouseEvent('click',true,true,window,1);
	d.getElementById('lhn-add-subscription').dispatchEvent(e);
	
	var ra = function(){
		d.getElementById('quickadd').value = addfeedUrl;
		var ee = d.createEvent('MouseEvent');
		ee.initMouseEvent('click',true,true,window,1);
		d.getElementById('quick-add-btn').dispatchEvent(ee);
	};
	
	setTimeout(ra,800);
	
};

var lipsShowShareOK = function(){
	shareBtn.style.color = 'green';
	shareBtn.innerHTML = 'OK';
	setTimeout("shareBtn.style.color = '';shareBtn.innerHTML='Share';",1000);
};

var lipsShowShareLoad = function(){waitEl.style.display='block';}
var lipsHideShareLoad = function(){waitEl.style.display='none';}

var lipsOnKeyDown = function(e){
	if(e.keyCode==83 && event.shiftKey) {
		doShare();
	}
};

window.addEventListener("keydown", lipsOnKeyDown, false);

