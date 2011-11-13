<?php 


require_once('functions.php');

if(user_exists($_GET['_USER_ID']) && auth($_GET['_USER_ID'])){
	
	$sharedItems = get_items($_GET['_USER_ID'],60);
	$sharedHashes = array();
	foreach($sharedItems as $item){
		$sharedHashes[] = array(
			'h'=>md5($item['url']),
			't'=>$item['tstamp']
		);
	};
	
	echo 'lips_loadSharedItemsCallback('.json_encode($sharedHashes).');'.allJSONPReturns();
	die();
	
}elseif(user_exists($_GET['_USER_ID']) && !auth($_GET['_USER_ID'])){
	echo getLoginCode('In order to load you previously shared items, please type in you share password:').allJSONPReturns();
}else{
	//user do not exists, probably the first time the plugin runs with that _USER_ID.
	//do nothing
	echo '/* user has no account here yet. your first share will create your account. */';
}

?>