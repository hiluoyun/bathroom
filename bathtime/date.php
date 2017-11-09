<?php
	/*
	*false 
	*closeTime
	*busy
	*true
	*noSelect
	*queue
	 */
	date_default_timezone_set('Asia/Shanghai');
	require_once("./util.php");
	$status = "false";
	if ($_GET['name'] && $_GET['house_id'] ){
		$sex = $_GET['sex'];
		$house_id = $_GET['house_id'];
		$cell_id = (int)$_GET['cell_id'] ;
		$name = $_GET['name'];
		$query_user = "select id from user where name = '$name'";
		$user_row = select($query_user);
		$user_res = $user_row->fetch_array();
		$user_id = $user_res[0];

		$query_time = "select start_time,end_time from bath_house where house_id = $house_id";
		$row = select($query_time);
		$flag = false;
		if ($row){
			$time_value = $row->fetch_array();
			$start_time = $time_value[0];
			$end_time = $time_value[1];
			$checkDayStr = date('Y-m-d',time());
			$startTime = strtotime($checkDayStr.$start_time);
			$endTime = strtotime($checkDayStr.$end_time);
			$now = time();
			if ($now > $startTime && $now < $endTime){
				$flag = true;
			}else{
				$status = "closeTime";
			}
		}

		if ($flag == true){
			if ($cell_id > 0 ){
				$update = "update bath_cell set status = 0 ,user_id = $user_id where cell_id = $cell_id and status =1";
				$suc = update($update);
				if ($suc > 0 ){
					$mytime = date('H:i:s',time());
					$sql = "INSERT INTO `date_queue`(`name`, `time`) VALUES ('$name','$mytime')";
					$effects = insert($sql);
					$status = "true";
				}else{
					$status = "busy";
				}
				
			}else{
				$sql = "select count(cell_id) from bath_cell where house_id = $house_id and sex = $sex and status = 1";
				$row = select($sql);
				$res = $row->fetch_array();
				if($res[0] > 0){
					$status = "noSelect";
				}else{
					$sql = "INSERT INTO `wait_queue`(`id`, `user_id`, `status`, `cell_id`) VALUES ('',$user_id,0,'')";
					$row = insert($sql);
					$status = "queue";
				}
			}
		}
		print json_encode(array("status"=> $status ));
	}else {
		print json_encode(array("status"=> "false" ));
	}
?>