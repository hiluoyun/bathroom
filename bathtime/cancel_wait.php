<?php
	date_default_timezone_set('Asia/Shanghai');
	require_once("./util.php");
	$status = "false";
	if($_GET['name']){
		$name = $_GET['name'];
		$sql = "select id from user where name = '$name'";
		$row = select($sql);
		$user_res = $row->fetch_array();
		$user_id = $user_res[0];

		$delete = "DELETE FROM `wait_queue` WHERE user_id = $user_id";
		$sr = delete($delete);
		$status = "true";
		print json_encode(array("status" => $status));
	}else {
		print json_encode(array("status"=> "false" ));
	}
?>