<?php 

require_once('functions.php');

$users = get_users();
$howMany = (count($users));

$from = (1320292504+5*60);//+(86400);
$to = time();

$min = $_GET['m']?$_GET['m']:360;

if($_GET['userCount']==1){
	echo $howMany;
	die();
}

echo '<body bgcolor="#111"><meta http-equiv="refresh" content="30;url=http://lipsumarium.com/greader/stats99?m='.$min.'&nc='.time().'">';


for($u=0;$u<100;$u++){
	echo '<div style="position:absolute;bottom:'.($u*10).'px;height:9px;border-bottom:1px solid #444;width:100%;left:0;"></div>';
}


$ii=0;
for($i=$from;$i<$to;$i+=($min*60)){
	
	$howMany = 0;
	foreach($users as $u){
		if($u['tstamp']<=$i) $howMany++;
	}
	
	echo '
	<div style="position:absolute;bottom:0;left:'.($ii*27).'px;width:22px;height:'.($howMany*10).'px;background:#555;color:#333;text-align:center;" title="'.date('d/m H:i',$i).'">'.$howMany.'</div>
	';
	
	$ii++;
}
$howMany = (count($users));
echo '
	<div style="position:absolute;bottom:-2px;left:'.($ii*27).'px;width:18px;height:'.($howMany*10-4+2).'px;background:#111;color:#555;border:2px dashed #555;text-align:center;" title="Now. Next report: '.date('d/m H:i',($i)).'">'.$howMany.'</div>
	';
echo '<div style="position:absolute;top:20px;left:20px;font-size:20px;color:#AAA;font-weight:bold;"><span style="font-size:40px;">'.$howMany.'</span> confirmed users</div>';

$q = 'select count(*) as total from greader_items ';
$res = mysql_query($q);
$r = mysql_fetch_assoc($res);
$howManyItems = $r['total'];

echo '<div style="position:absolute;top:80px;left:20px;font-size:20px;color:#AAA;font-weight:bold;"><span style="font-size:40px;">'.$howManyItems.'</span> shared items</div>';




?>