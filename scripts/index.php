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
        margin: 0;
        padding: 0;
      }
      .header {
        position: relative;
        top: 0;
        width: 100%;
        height: 100px;
        border-bottom: 1px black solid;
        -webkit-box-shadow: 5px 5px 30px 5px rgba(0,0,0,0.3); 
        box-shadow: 5px 5px 30px 5px rgba(0,0,0,0.3);
        font-size: 40px;
        font-weight:bold;
        padding: 5px;
        background-color: white;
      }
      .main {
        position: relative;
        top: 0;
        width: 100%;
        padding: 5px;
      }
    </style>
  </head>
  <body>
  <div class="header">
    Temperature in Atlanta, GA
  </div>
  <div>
<?php
flush();
ob_flush();
$json = file_get_contents('http://api.openweathermap.org/data/2.5/weather?zip=30303,us&appid=57d97ee2fb35e167103306cbef9279b3');
$obj = json_decode($json);
$temp = (($obj->main->temp - 273.15) * (9/5) + 32);
$t = intval($temp);
$s = intval(($temp - $p) * 10);
if ($s >= 5) $t++;
echo "The temperature is currently " . $t . "&#8457; (".$temp.")<br>";
?>
  </div>
  </body>
</html>
