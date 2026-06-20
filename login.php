<?php
  session_start();

  if ($_SERVER["REQUEST_METHOD"] !== "POST"):
    header("Location: ./index.php");
    exit();
  endif;

  $username = trim($_POST["nmUsername"] ?? "");
  $password = trim($_POST["nmPass"] ?? "");

  if( $username == "abc" ):
    if( $password == "1234" ):
      $_SESSION["usuario"] = "Sr/a ABC";
    else:
      $_SESSION["error"] = "Contraseña incorrecta";
    endif;
  else:
    $_SESSION["error"] = "Usuario no reconocido";
  endif;

  header("Location: ./index.php");
  exit();
?>
