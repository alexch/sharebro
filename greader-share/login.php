<?php 


require_once('functions.php');


$q = 'select * from greader_users where uid=\''.$_GET['_USER_ID'].'\' and secret=\''.$_GET['pass'].'\' limit 1';
$res = mysql_query($q);
$r = mysql_fetch_assoc($res);

if($r['uid']==$_GET['_USER_ID']){
	$_SESSION['greader_USER_ID']=$r['uid'];
	echo 'lipsLoginCallback();'.allJSONPReturns();
}else{
	echo 'alert("Wrong password.");'.allJSONPReturns();
}



?>