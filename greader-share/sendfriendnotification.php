<?php 

require_once('functions.php');

if(user_exists($_GET['_USER_ID'])){
	
	if(auth($_GET['_USER_ID'])){
		$user = get_user($_GET['_USER_ID']);
	
		if (!validEmail($_GET['friend_USER_EMAIL'])) {
			//not an email
			die('alert("'.$_GET['friend_USER_EMAIL'].' is not a valid email address.");'.allJSONPReturns());
		}
		
		if(user_exists($_GET['friend_USER_EMAIL'],'email')){
			die('alert("'.$_GET['friend_USER_EMAIL'].' is already using the script :)");'.allJSONPReturns());
		}else{
			mail($_GET['friend_USER_EMAIL'],'Reader Friend Request','Hello,
			
Your friend '.$user['email'].' is using Google Reader and finally got the Share button back !
As well as a friend list, and the comments will be back soon.

Your friend tried to follow you, but you need to install a small plugin in order to share.

To be able to share stuff with your friend, please install this plugin:
http://userscripts.org/scripts/show/117058

Then go to Google Reader, refresh the tab and you will see a [Share button]. 
Click on it to start sharring just like old times ;)


--
The unofficial Reader Team
Lipsumarium.com
			
			
			');
			//mail('piremmanuel@gmail.com','New reader request','Trying to convert '.$_GET['friend_USER_EMAIL']);
			die('alert("We just sent an email to '.$_GET['friend_USER_EMAIL'].'.");'.allJSONPReturns());
		}
	
	
		
		
	}else{
		echo getLoginCode().allJSONPReturns();
	}
	
}else{
	echo 'lipsDisalog.alert("User has no account here");'.allJSONPReturns();
}


?>