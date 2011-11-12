<?php 

require_once('functions.php');

if($_GET['_USER_ID']!='' && auth($_GET['_USER_ID'])){
	
	if(trim($_GET['url'])=='') die('alert("Uups, error here. Please try again later");');
	
	if(postItem($_GET['_USER_ID'],$_GET['url'],trim($_GET['title']),$_GET['body'])){
		echo 'lipsShowShareOK();'.allJSONPReturns();
	}else{
		echo 'alert("post failed.")'.allJSONPReturns();
	}
	
}else{
	
	if(!user_exists($_GET['_USER_ID'])){
		echo '
		var d=document;
		if(confirm("It seems this is the first time you share using our system.\\nYou will need to set a password so nobody can share for you. (We won\'t ask for a password everytime you share, don\'t worry).\\n\\nDo you want to set your password now ?")){
			var pass = prompt("Please set a password");
			if(pass.trim()!=""){
				var pass2 = prompt("Please enter the password again");
				if(pass==pass2){
					var ss = d.createElement("script");
					ss.src = "http://lipsumarium.com/greader/subscribe?_USER_ID="+encodeURIComponent(window._USER_ID)+"&email="+encodeURIComponent(window._USER_EMAIL)+"&pass="+lipsMD5(pass);
					d.body.appendChild(ss);
					lipsShowShareLoad();
				}else{
					alert("Passwords do not match. Please try again by clicking the Share button.");
				}
			}
		}
		
		'.allJSONPReturns();
	}else{
		
		echo getLoginCode().allJSONPReturns();
		
	}
	
	
}


?>