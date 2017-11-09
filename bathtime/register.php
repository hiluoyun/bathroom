<?php
	require_once("./util.php");
	$status = "false";

	if($_GET['username'] && $_GET['password']  && $_GET['location']){
		$name = $_GET['username'];
		$password = $_GET['password'];
		$sex = $_GET['sex'];
		$location = $_GET['location'];
		
		$sql = "insert into user values('','$name','$password','$sex','')";
		$mysqli = connect();
		$result = $mysqli->query($sql);
		$lastId = $mysqli->insert_id;
		$mysqli->close();

		// print($lastId);
		$sql_portrait = "insert into personal_profile (user_id,local_id) values('$lastId','$location')";

		$res = update($sql_portrait);
		if($result && $res){
			$status = "true";
		}
		print json_encode(array( "username"=>$name,"status"=>$status,"user_id"=>$lastId));
	}else{
		print json_encode(array( "status"=>"false" ));
	}
?>