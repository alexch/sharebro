<?php 
session_start();


require_once('dbconnect.php');

$_GET['_USER_ID'] = addslashes($_GET['_USER_ID']);




function auth($userID){
	
	return ($_SESSION['greader_USER_ID'] == $userID);
	
}

function postItem($userID,$url,$title,$body){
	$q = 'insert into greader_items (user_id,url,title,body,tstamp) values (\''.$userID.'\',\''.addslashes($url).'\',\''.addslashes($title).'\',\''.addslashes($body).'\','.time().')';
	return mysql_query($q);
}

function user_exists($userID,$col='uid'){
	$q = 'select count(*) as total from greader_users where '.$col.'=\''.$userID.'\' limit 1';
	//echo $q;
	$res = mysql_query($q);
	$r = mysql_fetch_assoc($res);
	return ($r['total']==1);
}

function get_user($userID,$col='uid'){
	$q = 'select * from greader_users where '.$col.'=\''.$userID.'\' limit 1';
	$res = mysql_query($q);
	$r = mysql_fetch_assoc($res);
	return $r;
}
function get_post($url,$userID){
	$q = 'select * from greader_items where url=\''.addslashes($url).'\' and user_id=\''.$userID.'\' limit 1';
	$res = mysql_query($q);
	$r = mysql_fetch_assoc($res);
	return $r;
}

function get_friends($userID){
	$return = array();
	$q = 'select u.email,u.uid 
	from greader_user2friend u2f 
	join greader_users u on u.uid=u2f.friend_id 
	where u2f.user_id=\''.$userID.'\'';
	$res = mysql_query($q);
	while($r = mysql_fetch_assoc($res)){
		$return[] = $r;
	}
	return $return;
}

function get_users(){
	$return = array();
	$q = 'select * from greader_users order by tstamp asc';
	$res = mysql_query($q);
	while($r = mysql_fetch_assoc($res)){
		$return[] = $r;
	}
	return $return;
}

function add_friend($userID,$friendID){
	$q = 'insert into greader_user2friend (user_id,friend_id,tstamp) value(\''.$userID.'\',\''.$friendID.'\','.time().')';
	return mysql_query($q);
}

function getLoginCode($text='Please type in you share password:'){
	return '
		var d=document;
		
		lipsDialog.promptInputType = "password";
		lipsDialog.prompt("'.$text.'",{onOK:function(pass){
			insertScript("http://lipsumarium.com/greader/login?_USER_ID="+encodeURIComponent(window._USER_ID)+"&pass="+lipsMD5(pass));
			lipsShowShareLoad();
		}});
		
		';
}


function get_items($userID,$max=100){
	$return = array();
	$q = 'select * from greader_items where user_id=\''.$userID.'\' order by tstamp desc limit '.intval($max);
	$res = mysql_query($q);
	while($r = mysql_fetch_assoc($res)){
		$return[] = $r;
	}
	return $return;
}

function output_feed($userID){
	$user = get_user($userID); 
	$items = get_items($userID,50);
	
	
	
	header('Content-Type: application/rss+xml; charset=UTF-8'."\n");
	
	echo '<?xml version="1.0" encoding="UTF-8" ?>';
	echo '<rss version="2.0">';
	echo '<channel>';
	echo '<title>My shared feed</title>';
	echo '<link>http://www.lipsumarium.com/greader/feed?_USER_ID='.$userID.'</link>';
	echo '<description></description>';
	
	
	foreach($items as $r){
	
		echo '<item>';
        echo '<title><![CDATA[' . htmlspecialchars(strip_tags(stripslashes($r['title']==''?$r['url']:$r['title']))) . ']]></title>';
        echo '<description><![CDATA[
        '.stripslashes($r['body']).'
        
        <p><a href="'.$r['url'].'" target="_blank">View full article &gt;&gt;</a></p>
        ]]></description>';
        echo '<link>' . htmlspecialchars(stripslashes($r['url']) ). '</link>';
        echo '<pubDate>' . date("D, d M Y H:i:s O", $r['tstamp']) . '</pubDate>';
        echo '</item>';
	}
	echo '</channel>';
    echo '</rss>';
    die();
}

function allJSONPReturns(){
	return 'lipsHideShareLoad();';
}

function validEmail($email)     {
	$email = trim ($email);
	if (strstr($email,' '))  return FALSE;
	return ereg('^[A-Za-z0-9\._-]+[@][A-Za-z0-9\._-]+[\.].[A-Za-z0-9]+$',$email) ? TRUE : FALSE;
}


function getElapsedString($date) {
	//print $date;	
	$t = time() - $date;
	
	if ($t<60)		
		if($t <> 1){
			return $t . " seconds ago";
		} else {
			return $t . " seconds ago";
		}		
	$t = round($t/60);		
	if ($t<60)
		if($t <> 1){
			return $t . " minutes ago";
		} else {
			return $t . " minute ago";
		}		
	$t = round($t/60);	
	if ($t<24){
		if($t<> 1){
			return $t . " hours ago";
		} else {
			return $t . " hour ago";
		}
	}		
	$t = round($t/24);
	if ($t<7){
		if($t <> 1){
			return $t . " days ago";
		} else {
			return $t . " day ago";
		}
	}
	$number_of_day = $t;
	$t = round($t/7);
	if ($t<4){
		$left_days = $number_of_day - ($t*7);
		$left_days_str = $left_days > 0 ? ' and '.$left_days.' day'.($left_days>1?'s':'') : '';
		if($t > 1){
			return $t . " weeks$left_days_str ago";
		} else {
			return $t . " week$left_days_str ago";  
		}
	}
	return date("F jS", $date);
}

function get_config($key){
	global $_config;
	
	if(!isset($_config[$key])){
		$q = 'select value from greader_config where key=\''.addslashes($key).'\' limit 1';
		$res = mysql_query($q);
		$r = mysql_fetch_assoc($res);
		$_config[$key] = $r['value'];
	}
	return $_config[$key];
	
}


?>