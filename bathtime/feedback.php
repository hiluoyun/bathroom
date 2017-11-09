<?php

	require_once("./util.php");
	$status = "false";
	if($_GET['name']){
		$name = $_GET['name'];
		$content = $_GET['content'];
		
		$sql = "insert into system_feedback (id, name, content) values ('', '$name', '$content')";
		$res = insert($sql);
		if($res > 0){
			$status = "true";
			print json_encode(array( "status"=> $status ));
		}else{
			print json_encode(array("status"=> $status ));
		}
		
	}else{
		print json_encode(array("status"=> "false" ));
	}
?>