<?php 

require_once('functions.php');

if(user_exists($_GET['_USER_ID'])){
	
	if(auth($_GET['_USER_ID'])){
		$friends = get_friends($_GET['_USER_ID']);
		echo 'lips_loadFriendsCallback('.json_encode($friends).');'.allJSONPReturns();
	}else{
		echo getLoginCode().allJSONPReturns();
	}
	
}else{
	echo 'lipsDialog.alert("User has no account here. please login first (try to share an item)");'.allJSONPReturns();
}


?>