<?php 

/**
 * must run locally on a mac
 */

list($last) = file('./last');

list($howMany) = file('http://lipsumarium.com/greader/stats99?userCount=1');

//echo $howMany;

$dif = $howMany-$last;

if($dif>0){
	exec('say '.$dif.' new user'.($dif>1?'s':'').'. Total users: '.$howMany);
	$h=fopen('./last','w');
	fwrite($h,$howMany);
}


echo '<meta http-equiv="refresh" content="30;url=http://localhost:8888/greader-share/realtimeStats.php?nc='.time().'">';


?>