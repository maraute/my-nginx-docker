<?php

// Zeigt alle Informationen (Standardwert ist INFO_ALL)
// phpinfo();

// Zeigt nur die Modul-Informationen.
// phpinfo(8) führt zum gleichen Ergebnis.
phpinfo(INFO_MODULES);

$redis = new Redis();
$redis->pconnect('redis', 6379);
echo "Visits so far: " . $redis->rPush('visits', date(DATE_ISO8601, time()));

?>

