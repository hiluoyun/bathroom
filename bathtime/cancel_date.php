<?php
	date_default_timezone_set('Asia/Shanghai');
	require_once("./util.php");
	$status = "false";
	if($_GET["cell_id"] && $_GET['name']){
		$cell_id = $_GET["cell_id"];
		$name = $_GET['name'];
		$sql = "select count(id) from wait_queue where status = 0";
		$res  = select($sql);
		$count_array = $res->fetch_array();
		$count = $count_array[0];

		$suc = 0;
		if ($count>0){
			$update = "update wait_queue set status = 1, cell_id = $cell_id where status = 0 order by id limit 1";
			$suc = update($update);
			$status = "true";
		}
		if($count == 0 || $suc == 0){
			$update = "update bath_cell set status =1 where cell_id = $cell_id";
			$suc = update($update);
			if ($suc>0){
				$status = "true";
			}else{
				$status = "failure";
			}
		}
		$delete = "DELETE FROM `date_queue` WHERE name = $name";
		$sr = delete($delete);

		print json_encode(array("status" => $status));
	}else {
		print json_encode(array("status"=> "false" ));
	}
?>