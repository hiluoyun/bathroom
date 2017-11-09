<?php

	require_once("./util.php");
	$status = "false";
	if($_GET['name']){
		$name = $_GET['name'];
		$sql = "select id from user where name = '$name'";
		$row = select($sql);
		$res = $row->fetch_array();
		$user_id = $res[0];

		$sql = "select portrait from personal_profile where user_id = $user_id";
		$portrait_row = select($sql);
		$result = $portrait_row->fetch_array();
		$portrait = $result[0];

		if($portrait == null){
			$status = "true";
		}else{
			$status = "success";
		}

		print json_encode(array("portrait" => $portrait ,"status"=> $status ));
	}else{
		print json_encode(array("status"=> "false" ));
	}
?>