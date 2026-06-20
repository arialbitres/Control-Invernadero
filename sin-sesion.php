<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Login - Control Invernadero</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f0f4f8; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-box { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 100%; max-width: 360px; text-align: center; }
        h2 { color: #1a365d; margin-bottom: 20px; font-size: 24px; }
        label { display: block; text-align: left; font-weight: 600; color: #4a5568; margin-top: 15px; }
        input { width: 100%; padding: 10px; margin-top: 5px; border: 1px solid #cbd5e0; border-radius: 4px; box-sizing: border-box; font-size: 14px; }
        button { width: 100%; background: #2b6cb0; color: white; border: none; padding: 12px; margin-top: 20px; border-radius: 4px; font-size: 16px; font-weight: bold; cursor: pointer; }
        button:hover { background: #2b6cb0; }
        .error { background: #fed7d7; color: #c53030; padding: 10px; border-radius: 4px; margin-bottom: 15px; font-size: 14px; font-weight: bold; }
    </style>
</head>
<body>

    <div class="login-box">
        <h2>Acceso Invernadero</h2>

        <?php if( isSet( $_SESSION["error"] ) ): ?>
          <p class="error" id="idParrafoError"><?= $_SESSION["error"] ?></p>
          <script>
            setTimeout( function(){ idParrafoError.remove() }, 3000 );
          </script>
        <?php unSet( $_SESSION["error"] ); ?>
        <?php endif; ?>

        <form action="./login.php" method="post">
            <label>Usuario / Email:</label>
            <input type="text" id="idUsername" name="nmUsername" placeholder="abc" required />

            <label>Contraseña / Clave:</label>
            <input type="password" id="idPass" name="nmPass" placeholder="1234" required />

            <button type="submit">Ingresar al Sistema</button>
        </form>
    </div>

</body>
</html>
