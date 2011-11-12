<?php 
session_start();

$_GET['_USER_ID'] = addslashes($_GET['_USER_ID']);


$db = mysql_connect('xxx','xxx','xxx') or die('alert("Database error.");'.allJSONPReturns());
mysql_select_db('xxx',$db) or die('alert("Database error.");'.allJSONPReturns());

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

function getLoginCode(){
	return '
		var d=document;
		
		
		var pass = prompt("Please type in you share password");
		
		var ss = d.createElement("script");
		ss.src = "http://lipsumarium.com/greader/login?_USER_ID="+encodeURIComponent(window._USER_ID)+"&pass="+lipsMD5(pass);
		d.body.appendChild(ss);
		lipsShowShareLoad();
		
		';
}


function output_feed($userID){
	$user = get_user($userID); 
	
	$q = 'select * from greader_items where user_id=\''.$userID.'\' order by tstamp desc limit 50';
	$res = mysql_query($q);
	
	header('Content-Type: application/rss+xml; charset=UTF-8'."\n");
	
	echo '<?xml version="1.0" encoding="UTF-8" ?>';
	echo '<rss version="2.0">';
	echo '<channel>';
	echo '<title>'.$user['email'].' shared feed</title>';
	echo '<link>http://www.lipsumarium.com/greader/feed?_USER_ID='.$userID.'</link>';
	echo '<description></description>';
	
	
	
	while($r = mysql_fetch_assoc($res)){
		 echo '<item>';
        echo '<title>' . stripslashes($r['title']==''?$r['url']:$r['title']) . '</title>';
        echo '<description><![CDATA[
        '.stripslashes($r['body']).'
        
        <p><a href="'.$r['url'].'" target="_blank">View full article &gt;&gt;</a></p>
        ]]></description>';
        echo '<link>' . stripslashes($r['url']) . '</link>';
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

?>