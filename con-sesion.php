<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Invernadero</title>
    <script src="http://localhost:3000/socket.io/socket.io.js"></script>
    <style>
        body { font-family: Arial, sans-serif; background: #fafafa; padding: 30px; text-align: center; }
        .container { max-width: 800px; margin: auto; }
        .card { background: white; padding: 25px; margin: 15px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); display: inline-block; min-width: 300px; vertical-align: top; }
        .btn-danger { background: #e53e3e; color: white; border: none; padding: 10px 15px; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .btn-nav { background: #4a5568; color: white; border: none; padding: 10px 15px; border-radius: 4px; cursor: pointer; text-decoration: none; margin-left: 10px; }
        progress { width: 100%; height: 20px; margin-top: 10px; }
        h3 { color: #2d3748; margin-top: 0; }
        #idEstadoActual { font-weight: bold; color: #2b6cb0; }
    </style>
</head>
<body>

    <div class="container">
        <h1>Control e Integración de Invernadero IoT</h1>
        <p>Bienvenido/a: <strong><?php echo $_SESSION["usuario"]; ?></strong></p>

        <button class="btn-danger" onclick="location.assign('./logout.php')">Cerrar sesión</button>
        <a class="btn-nav" href="./conectar-hardware.php" target="_blank">Abrir Puente Hardware 🔌</a>

        <br><br>

        <div class="card">
            <h3>Monitoreo de Humedad</h3>
            <p>Medida del sensor: <output id="idEjemplo">0.00</output> Volts</p>
            <progress id="idBarraSensor1" min="0" max="5" value="0" step="0.01"></progress>
        </div>

        <div class="card">
            <h3>Estado de la MEF</h3>
            <p>Estado detectado: <span id="idEstadoActual">Esperando datos...</span></p>
            <hr>
            <button class="btn-danger" style="background:#2b6cb0;" onclick="fnEnviarComando('e0')">Forzar Config (e0)</button>
            <button class="btn-danger" style="background:#dd6b20;" onclick="fnEnviarComando('e1')">Forzar Seco (e1)</button>
            <button class="btn-danger" style="background:#38a169;" onclick="fnEnviarComando('e2')">Forzar Húmedo (e2)</button>
        </div>
    </div>

    <script>
        let _socket = io("http://localhost:3000");

        _socket.on("servidor-dice:lectura-sensor-1", function( _medidaRecibida ) {
            document.getElementById("idEjemplo").value = parseFloat(_medidaRecibida).toFixed(2);
            document.getElementById("idBarraSensor1").value = _medidaRecibida;
        });

        _socket.on("servidor-dice:cambio-estado", function( estado ) {
            let texto = "Estado " + estado;
            if(estado == "0") texto += " (Configuración)";
            if(estado == "1") texto += " (Tierra Seca 🔴)";
            if(estado == "2") texto += " (Tierra Húmeda 🟢)";
            document.getElementById("idEstadoActual").innerText = texto;
        });

        function fnEnviarComando(cmd) {
            console.log("Enviando comando de estado via Sockets:", cmd);
            _socket.emit("comando-desde-dashboard", cmd);
        }
    </script>
</body>
</html>
