<?php 


require_once('functions.php');

$hash = md5(get_config('subscribe-salt-head').$_GET['_USER_ID'].get_config('subscribe-salt-foot'));

if(!user_exists($_GET['_USER_ID'])){
	if($_GET['hash']){
		if($_GET['hash']==$hash){
			if(is_file('./presub/'.$_GET['_USER_ID'])){
				list($email,$pass) = file('./presub/'.$_GET['_USER_ID']);
				$q = 'insert into greader_users (uid,tstamp,email,secret) values (\''.$_GET['_USER_ID'].'\','.time().',\''.trim($email).'\',\''.trim($pass).'\')';
				if(mysql_query($q)){
					echo '<h1>Finished ! You may now share just like before ! </h1>
					<p>Here is your shared feed: <a href="http://lipsumarium.com/greader/feed?_USER_ID='.$_GET['_USER_ID'].'" target="_blank">http://lipsumarium.com/greader/feed?_USER_ID='.$_GET['_USER_ID'].'</a></p>
					<p>Your friends may now add you via your email in gReader if they have the plugin, or add this feed to any feed reader so they can follow you, just like old times !</p>
					<p>Tell your friends about it so they make one too and you can follow them :)</p>
					<p>&nbsp;</p>
					<h2>Great, but Reader still looks a bit weird</h2>
					<p>I think so too, so i made another plugin for that ! <a href="http://userscripts.org/scripts/show/116890" target="_blank">http://userscripts.org/scripts/show/116890</a></p>
					<h2>Unfortunaltely, I\'m not Google.</h2>
					<p>Google Reader is an amazing tool, as almost all Google tools. They put a lot of time and resources to achieve this kind of products. So they have lots of great peoples, and money. I\'m alone and not that rich.</p>
					<p>That means the server I have do not compete with Google\'s servers. Your shared items will stay in your shared feed for 1 month. But don\'t worry, as Google loves to backup the whole Internet, they actually backup this shared feed too, as long as 1 user has it in Google Reader, they have it. I\'m looking for partners in hosting.</p>
					
					<h2>Maybe YOU are Google ?</h2>
					<p>If you have resources and want to participate to this, you will be welcomed with a big cake and cookies ! I would love someone with more resources than me participate in this project or host it.</p>
					<p>And if you really are working at Google, I have a message: You screwed up big time.</p>
					<p><a href="http://lipsumarium.com/contact">Contact me</a></p>
					';
					
					$_SESSION['greader_USER_ID'] = $_GET['_USER_ID'];
					

				}else echo 'Oops, something went wrong. Please try again later.';
			}else{
				echo 'Woops, something went wrong. Very sorry for this. Please try again later.';
			}
		}else{
			echo 'Hash error. (not that hash)';
		}
	}else{
		
		$h = fopen('./presub/'.$_GET['_USER_ID'],'w');
		fwrite($h,$_GET['email']."\n".$_GET['pass']);
		fclose($h);
		
		if(mail($_GET['email'],'GReader share verification email.','Now that we made sure you own this email address, gently click on the following link to activate you account: http://lipsumarium.com/greader/subscribe?_USER_ID='.$_GET['_USER_ID'].'&hash='.$hash)){
			echo 'lipsDialog.alert("We just sent a verification email to '.$_GET['email'].'. Please check your mailbox.");'.allJSONPReturns();
		}else{
			echo 'lipsDialog.alert("Problem while sending email to '.$_GET['email'].'. Please try again later.");'.allJSONPReturns();
		}
	}
	
	
	
}else{
	echo 'lipsDialog.alert("User '.$_GET['_USER_ID'].' ('.$_GET['email'].') is already registered.");'.allJSONPReturns();
}


?>