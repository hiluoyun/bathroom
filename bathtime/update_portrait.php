<?php

	require_once("./util.php");
	$status = "false";
	if($_GET['name']){
		$name = $_GET['name'];
		
		$sql = "select id from user where name = '$name'";
		$row = select($sql);
		$res = $row->fetch_array();
		$user_id = $res[0];

		$portrait = "/bathResource/portrait_".((string)$name).".png";
		$insert_sql = "update personal_profile set portrait='$portrait' where user_id=$user_id";
		$count = update($insert_sql);
		if($count > 0){
			$status = "true";
			print json_encode(array("status"=> $status ,"user_id"=>$user_id));
		}else{
			$status = "false";
			print json_encode(array("status"=> $status ));
		}
	}else{
		print json_encode(array("status"=> "false" ));
	}
?>

