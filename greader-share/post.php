<?php 

require_once('functions.php');

if($_GET['_USER_ID']!='' && auth($_GET['_USER_ID'])){
	
	if(trim($_GET['url'])=='') die('lipsDialog.alert("Uups, error here. Please try again later");');
	
	$post = get_post($_GET['url'],$_GET['_USER_ID']);
	
	if(!$_GET['allowRepost'] && $post['url']!=''){
		
		//repost
		
		die('
		lipsDialog.confirm("It seems you already shared this item '.getElapsedString($post['tstamp']).'. <br/><br/>Do you want to share it again ?",{
			onOK:function(){
				insertScript("http://lipsumarium.com/greader/post?_USER_ID='.urlencode($_GET['_USER_ID']).'&url='.urlencode($_GET['url']).'&title='.urlencode(stripslashes($_GET['title'])).'&body='.urlencode(stripslashes($_GET['body'])).'&allowRepost=1&nc='.time().'");
			}
		});
		'.allJSONPReturns());
	}
	
	if(postItem($_GET['_USER_ID'],$_GET['url'],trim($_GET['title']),$_GET['body'])){
		echo 'lipsShowShareOK();'.allJSONPReturns();
	}else{
		echo 'lipsDialog.alert("post failed.")'.allJSONPReturns();
	}
	
}else{
	
	if(!user_exists($_GET['_USER_ID']) ){ 
		echo '
		
		
		lipsDialog.confirm("It seems this is the first time you share using our system.<br/>You will need to set a password so nobody can share for you. (We won\'t ask for a password everytime you share, don\'t worry).<br/><br/>Do you want to set your password now ?",{
			onOK:function(){
				lipsDialog.promptInputType = "password";
				lipsDialog.prompt("Please set a password",{
					onOK:function(pass){
					console.log(arguments);
						if(pass.trim()!=""){
							window.lipsPass1 = pass;
							lipsDialog.promptInputType = "password";
							lipsDialog.prompt("Please enter your password again",{
								onOK: function(pass2){
									var pass = window.lipsPass1;
									window.lipsPass1="";
									
									if(pass==pass2){
										insertScript("http://lipsumarium.com/greader/subscribe?_USER_ID="+encodeURIComponent(window._USER_ID)+"&email="+encodeURIComponent(window._USER_EMAIL)+"&pass="+lipsMD5(pass));
										lipsShowShareLoad();
									}else{
										lipsDialog.alert("Passwords do not match. Please try again by clicking the Share button.");
									}
								}
							});
						
							
							
						}
					}
				});
			
				
				
			}
		})
		
		
		
		'.allJSONPReturns();
	}else{
		
		echo getLoginCode().allJSONPReturns();
		
	}
	
	
}


?>