
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



var ss = d.createElement('script');
ss.src = 'http://lipsumarium.com/greader/md5.min.js';
d.body.appendChild(ss);

var lipscss = d.createElement('style');
lipscss.innerHTML = '#lipsFriendList{margin-left:42px;}';
d.body.appendChild(lipscss);


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

var topbar=d.getElementById('viewer-top-controls');
var shareBtn = d.createElement('div');
shareBtn.className = 'goog-inline-block jfk-button jfk-button-standard viewer-buttons';
shareBtn.id="share-button";
shareBtn.style.float="right";
shareBtn.style.cssFloat="right";
shareBtn.innerHTML = '<div class="goog-inline-block goog-flat-menu-button-caption">Share</div>';
shareBtn.addEventListener('click',doShare);
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
fl_addWrap.innerHTML = '<input type="text" placeholder="Add friends by email" id="fl_addInput" /><a style="padding-top:2px;display:block;color:blue;text-decoration:underline;" href="http://lipsumarium.com/help-to-spread-the-word/" title="Help to promote this plugin, tell your Reader friends about it." target="_blank">Spread the word !</a>';
fl_wrap.appendChild(fl_addWrap);



var shareURL='';
function doShare(){
	var e = d.getElementById('current-entry');
	if(!e){
		alert('No item selected');
	}else{
		var aEl=getByClass(e,'a','entry-title-link');
		var a=null;
		if(aEl){
			a=aEl.href;
			t=aEl.innerHTML;
			
			var h2 = getByClass(e,'h2','entry-title');
			t = h2.innerHTML;
			
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
			alert('Woops.. this should work! Please report bug to @lipsumar');
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
		alert("Your friend\'s feed will be added to your feeds.\n\nPut it in a folder named \"Friends\", and voila!\nNote that you have an option to rename the feed.");
		
		lips_addFeed('http://lipsumarium.com/greader/feed?_USER_ID='+friendID);
		
	}else{
		if(confirm("It seems your friend "+friendEmail+" is not yet using this plugin.\n\nDo you want us to send a mail to your friend to warn him about this script ? (no spam, promise)")){
			insertScript('http://lipsumarium.com/greader/sendfriendrequest?friend_USER_EMAIL='+encodeURIComponent(lips_addingFriendEmail)+"&_USER_ID="+encodeURIComponent(window._USER_ID)+"&nc="+Math.random());
		}
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
	setTimeout("shareBtn.style.color = '';shareBtn.innerHTML='Share';",800);
};

var lipsShowShareLoad = function(){waitEl.style.display='block';}
var lipsHideShareLoad = function(){waitEl.style.display='none';}

var lipsOnKeyDown = function(e){
	if(e.keyCode==83 && event.shiftKey) {
		doShare();
	}
}

window.addEventListener("keydown", lipsOnKeyDown, false);

/* features under testing, limited to beta testers. if you want to be included, contact me */
//if(window._USER_EMAIL=='paulmarique@gmail.com' || )

