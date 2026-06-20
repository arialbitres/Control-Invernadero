<?php
  session_start();

  $haySesion = isSet($_SESSION["usuario"]);

  if( $haySesion ):
    include "con-sesion.php"; // Dashboard
  else:
    include "sin-sesion.php"; // Formulario de inicio de sesión
  endif;
?>