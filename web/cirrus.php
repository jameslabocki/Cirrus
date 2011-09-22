<?php
if(!isset($_POST['submit'])){

$workload = "";
$action = "";
$number = "";
}
?>
<div id="main">
<h1>Cirrus</h1>
<form action="cirrus.php" method="post">
<h3>Workloads to Scale</h3>
<select name="workload" selected='' style="width:150px">
<option value="www">httpd</option>
<option value="mrggrid">MRG Grid</option>
<option value="JBoss EAP">JBoss EAP</option>
</select>

<h3>Action</h3>
<select name="action" selected=''style="width:150px">
<option value="add">add</option>
<option value="remove">remove</option>
<option value="list">remove</option>
</select>

<h3>Amount</h3>
<select name="number" selected=''style="width:150px">
<option value="1">1</option>
<option value="2">2</option>
<option value="3">3</option>
<option value="4">4</option>
<option value="5">5</option>
<option value="6">6</option>
<option value="7">7</option>
<option value="8">8</option>
<option value="9">9</option>
<option value="10">10</option>
</select>

<br/>
<br/>
<br/>
<input class="button" name="submit" type="submit" style="width:150px" value="Submit" />
</form>

<?php

if(isset($_POST['submit'])){
  $workload = $_POST['workload'];
  $action = $_POST['action'];
  $number = $_POST['number'];
  $x = 1;
}
if(($workload && $action && $number) != NULL) {
  while ($x <= $number){
//    echo "<h4>Bringing $workload $x online.</h4>";
    $output = shell_exec("/usr/local/Cirrus/Cirrus/bin/Cirrus.sh -s $workload $action");
//    echo $output;
    $x++;
  }
}

?>

