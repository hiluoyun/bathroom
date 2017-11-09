<?php
	require_once("./util.php");
	$status = "false";
	if($_GET['username'] && $_GET['password']){
		$name = $_GET['username'];
		$password = $_GET['password'];
		$sql = "select password from user where name = '$name'";
		$row = select($sql);
		$res = $row->fetch_array();
		if($res[0] != null && $res[0] == $password ){
			$status = "true";
		}
		print json_encode(array("username" => $name ,"status"=> $status ));
	}else{
		print json_encode(array("status"=> "false" ));
	}
?>