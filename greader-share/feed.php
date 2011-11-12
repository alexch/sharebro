<?php 

require_once('functions.php');

if($_GET['_USER_ID']!=0){
	
	if(user_exists($_GET['_USER_ID'])){
		output_feed($_GET['_USER_ID']);
		die();
	}else{
		echo 'You need to create an account first.';
	}
	
}else{
	echo 'You need to add your userID.';
}


?>