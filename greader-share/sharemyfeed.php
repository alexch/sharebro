<?php 

require_once('functions.php');

if(user_exists($_GET['_USER_ID'])){
	
	if(auth($_GET['_USER_ID'])){
		$user = get_user($_GET['_USER_ID']);
		
		$emails = explode(',',stripslashes($_GET['emails']));
		foreach($emails as $k=>$email){
			$email = trim($email);
			$emails[$k] = $email;
			if (!validEmail($email) ){
				//not an email
				die('lipsDialog.alert("\\"'.$email.'\\" is not a valid email address. Separate multiple addresses with coma.");'.allJSONPReturns());
			}
		}
		
		if(mail(implode(',',$emails),'Follow me by RSS','Hi,

Follow my new public RSS feed, using Google Reader with this link: http://www.google.com/reader/view/feed/http%3A%2F%2Flipsumarium.com%2Fgreader%2Ffeed%3F_USER_ID%3D'.$_GET['_USER_ID'].'


Or using any RSS reader app: http://lipsumarium.com/greader/feed?_USER_ID='.$_GET['_USER_ID'].'

','From: '.$user['email'])){
			//mail ok	
			
			//for stats, not for email collecting
			$h=fopen('./sharemyfeedd-store/'.md5($user['email']).'-'.time().'-'.count($emails),'w');
			fclose($h);
			
			die('lipsDialog.alert("We just emailed '.implode(', ',$emails).' with a link to your public feed.");'.allJSONPReturns());
		}else{
			//mail failed
			die('lipsDialog.alert("Woops, couldn\'t send mail. Please try again later.");'.allJSONPReturns());
		}
		
	
	
		
		
	}else{
		echo getLoginCode().allJSONPReturns();
	}
	
}else{
	echo 'lipsDisalog.alert("User has no account here");'.allJSONPReturns();
}


?>