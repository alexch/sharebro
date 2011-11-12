<?php 

require_once('functions.php');

//if(user_exists($_GET['_USER_ID'])){
	
	//if(auth($_GET['_USER_ID'])){
		
		if (!validEmail( $_GET['friend_USER_EMAIL'])) {
			//not an email
			die('alert("'.$_GET['friend_USER_EMAIL'].' is not a valid email address.");'.allJSONPReturns());
		}
		
		
		if(trim($_GET['friend_USER_EMAIL'])==''){
			echo 'alert("Error: friend is empty.")'.allJSONPReturns();
			die();
		}
		$_GET['friend_USER_EMAIL'] = strtolower($_GET['friend_USER_EMAIL']);
		
		if(user_exists(str_replace('.','',$_GET['friend_USER_EMAIL']),'replace(replace(email,\'\\n\',\'\'),\'.\',\'\')')){
			$friend = get_user(str_replace('.','',$_GET['friend_USER_EMAIL']),'replace(replace(email,\'\\n\',\'\'),\'.\',\'\')');
			//add_friend($_GET['_USER_ID'],$friend['uid']);
			echo 'lips_addFriendCallBack(true,"'.trim($friend['email']).'","'.$friend['uid'].'");'.allJSONPReturns();
			die();
		}else{
			die('lips_addFriendCallBack(false,"'.$_GET['friend_USER_EMAIL'].'");'.allJSONPReturns());
		}
	
	
	
		
	/*	
	}else{
		echo getLoginCode().allJSONPReturns();
	}*/
	/*
}else{
	echo 'alert("You need to first share an item.");'.allJSONPReturns();
}*/


?>