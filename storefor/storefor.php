<?php

// storefor.php v1.00 (23rd September 2013) by Andy Davison
//  This is used alongside storefor.sh to generate new Store directories.
//  Calls should specify the user and group; storefor.sh does the creation.

$user = $_GET["user"];
$group = $_GET["group"];
$file = "/tmp/storefor_".$user;
file_put_contents($file, $group);

?>