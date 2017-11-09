<?php

// $date1=date_create("2013-03-15");
// $date2=date_create("2013-12-12");
// $diff=date_diff($date1,$date2);
// print_r($diff);
// var_dump($diff);

// $str  = date("h-i-s");
// var_dump($str);

// echo date("l jS \of F Y h:i:s A");
// var_dump(getdate());
date_default_timezone_set('Asia/Shanghai');
$datetime = date("Y-m-d H:i:s",time());
print($datetime);
print("<br>");
print( date('H:i:s',time()));

$checkDayStr = date('Y-m-d ',time());
print($checkDayStr);
$startTime = strtotime($checkDayStr."08:00".":00");
print($startTime);
$endTime = strtotime($checkDayStr."20:00".":00");
print($startTime);

var_dump( time() );



?>