<?php
ob_implicit_flush();
header('X-Accel-Buffering: no');
ini_set("allow_url_fopen", 1);
?>
<html>
  <head>
    <title>Test Website</title>
    <style>
      * {
        font-family: "Palatino Linotype", "Book Antiqua", Palatino, serif;
        font-size: 25px;
        letter-spacing: 0px;
        word-spacing: 2px;
        color: #020080;
        font-weight: normal;
        text-decoration: none;
        font-style: normal;
        font-variant: normal;
        text-transform: none;
        background: #BAC6D6 none no-repeat scroll 0 0;
      }
    </style>
  </head>
  <body>
<?php
flush();
ob_flush();
$json = file_get_contents('http://api.openweathermap.org/data/2.5/weather?zip=30127,us&appid=57d97ee2fb35e167103306cbef9279b3');
$obj = json_decode($json);
$temp = (($obj->main->temp - 273.15) * (9/5) + 32);
$t = intval($temp);
$s = intval(($temp - $p) * 10);
if ($s >= 5) $t++;
echo "<br><br>The temperature is currently " . $t . "&#8457; (".$temp.")<br>";
?>
  </body>
</html>
