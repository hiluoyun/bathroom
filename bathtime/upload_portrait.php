<?php
		require_once("./util.php");
		$error = $_FILES['fname']['error'];
		$size = $_FILES['fname']['size'];
		$type = $_FILES['fname']['type'];
		$path = "/var/www/html/bathResource/";
		$status = "false";
		if( $error == UPLOAD_ERR_OK && strpos($type,"image")!==false ){
			$name = $_FILES['fname']['name'];
			$tmpPath = $_FILES['fname']['tmp_name'];
			$suc = move_uploaded_file($tmpPath,$path.$name);
			if($suc==true){
				$status = "true";
			}else
			{
				$status = "false";
			}
			print json_encode(array("status"=> $status ));
		}else{
			print json_encode(array("status"=> $status ));
		}
		
?>