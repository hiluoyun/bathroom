<?php
	require_once("./util.php");
	$status = "false";
	if($_GET['opr']){
		$opr = $_GET['opr'];
		switch ($opr) {
			case 'house':
				if($_GET['id']){
					
				}
				break;
			
			default:
				# code...
				break;
		}

		$name = $_GET['username'];
		$password = $_GET['password'];
		$sql = "select password from user where name = '$name'";
		$row = select($sql);
		$res = $row->fetch_array();
		if($res[0] != null && $res[0] == $password ){
			$status = "true";
		}
		print json_encode(array("data" => $name ,"status"=> $status ));
	}else{
		print json_encode(array("status"=> "false" ));
	}
?>