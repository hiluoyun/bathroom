<?php

	require_once("./util.php");
	$status = "false";
	if($_GET['sql']){
		$sql = $_GET['sql'];
		$res = array();
		$row = select($sql);
		if($row){
			$status = "true";
			$i = 0 ;
			while($tmp = $row->fetch_assoc()){
				$res[$i] = $tmp;
				// print($tmp[1]);
				$i = $i+1;
			}
		}
		print json_encode(array("data" => $res ,"status"=> $status ));
	}else{
		print json_encode(array("status"=> "false" ));
	}
?>
