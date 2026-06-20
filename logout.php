<?php
  session_start();
  session_unset();
  session_destroy();

  // Redirecciona al index.php relativo al entorno actual
  header("Location: ./index.php");
  exit();
?>
