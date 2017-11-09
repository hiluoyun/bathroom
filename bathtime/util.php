<?php
	function connect()
	{
		$mysqli = new mysqli("localhost", "root", "", "bathtime");
		// $mysqli = new mysqli("localhost", "root", "95luohui", "bathtime");
		$mysqli->set_charset("utf8");

		if ($mysqli->connect_errno) {
		    printf("Connect database failed: %s\n", $mysqli->connect_error);
		    exit();
		}
		return $mysqli;
	}

	function select($sql){
		$mysqli = connect();
		$result = $mysqli->query($sql);
		$mysqli->close();
		if(! $result ){
			echo "select error";
			exit();
		}
		return $result;
	}

	function insert($sql){
		$mysqli = connect();
		$mysqli->query($sql);
		$result = $mysqli->affected_rows;
		$mysqli->close();
		return $result;
	}

	function delete($sql){
		$mysqli = connect();
		$mysqli->query($sql);
		$result = $mysqli->affected_rows;
		$mysqli->close();
		return $result;
	}

	function update($sql){
		$mysqli = connect();
		$mysqli->query($sql);
		$result = $mysqli->affected_rows;
		$mysqli->close();
		return $result;
	}

?>