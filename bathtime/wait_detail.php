<?php
	ini_set("display_errors", "Off");
	error_reporting(E_ALL | E_STRICT);
	date_default_timezone_set('Asia/Shanghai');
	require_once("./util.php");
	$status = "false";
	if($_GET['name']){
		$name = $_GET['name'];
		$sex = $_GET['sex'];
		$sql = "select id from user where name = '$name'";
		$row = select($sql);
		$user_res = $row->fetch_array();
		$user_id = $user_res[0];

		$sql = "select cell_id from wait_queue where user_id = $user_id and status = 1";
		$row = select($sql);
		$res = $row->fetch_array();
		$sce = -1;
		if($res != null){
			$sce = $res[0];
		}
		if($sce < 0){
			$sql = "select id from wait_queue where user_id = $user_id";
			$row = select($sql);
			$wait_res = $row->fetch_array();
			$wait_id = $wait_res[0];

			$sql = "select count(id) from wait_queue where id <= $wait_id and status = 0";
			$row = select($sql);
			$count_res = $row->fetch_array();
			$position = $count_res[0];


			$sql = "select count(cell_id) from bath_cell where sex = $sex";
			$row = select($sql);
			$count_res = $row->fetch_array();
			$total = $count_res[0];

			$estimate = ( 24*60 / ((int)$total) ) * ((int)$position) ;

			$status = "true";
			print json_encode(array("estimate" => $estimate ,"status"=> $status ,"position"=> 
				$position ));
		}else{
			$status = "success";
			$mytime = date('H:i:s',time());
			$sql = "INSERT INTO `date_queue`(`name`, `time`) VALUES ('$name','$mytime')";
			$effects = insert($sql);
			print json_encode(array("status" => $status,"cell_id"=> $sce));
		}
		
	}else{
		print json_encode(array("status"=> "false" ));
	}
?>