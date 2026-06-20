<?php
  session_start();
  if(!isset($_SESSION["usuario"])){ header("Location: ./index.php"); exit(); }
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Conector Serial - Hardware</title>
    <script src="http://localhost:3000/socket.io/socket.io.js"></script>
    <script src="https://gorosito.red/componentes"></script>
    <style>
        body { font-family: monospace; background: #1a202c; color: #63b3ed; padding: 20px; text-align: center; }
        .log-box { background: #2d3748; padding: 20px; border-radius: 5px; text-align: left; max-width: 600px; margin: 20px auto; height: 25px; overflow-y: auto; color: #48bb78; }
    </style>
</head>
<body>

    <h2>Puente de Comunicación: WebSerial ⇄ WebSockets</h2>
    <p>Este archivo lee tu placa física o el puente virtual mediante la herramienta del profesor.</p>

    <arduino-usb id="idArduino" eventos="eventosArduino"></arduino-usb>

    <div class="log-box" id="consola">Esperando conexión serial de la placa...</div>

    <script>
        let _socket = io("http://localhost:3000");

        // La librería del profesor espera un objeto de eventos. Cada línea
        // completa recibida por WebSerial llega al método `renglon`.
        window.eventosArduino = {
            renglon: fnLeidoArduino,
            conectado: function() {
                document.getElementById("consola").innerText = "Arduino conectado. Esperando datos...";
            },
            desconectado: function() {
                document.getElementById("consola").innerText = "Arduino desconectado.";
            },
            cancelado: function(mensaje) {
                document.getElementById("consola").innerText = mensaje;
            }
        };

        function fnLeidoArduino( _fraseDelArduino ) {
            _fraseDelArduino = _fraseDelArduino.trim();
            document.getElementById("consola").innerText = "Última línea: " + _fraseDelArduino;

            // 1. Si el Arduino reporta un estado de la MEF (ej: "Estado=1")
            if(_fraseDelArduino.includes("Estado=")) {
                let estado = _fraseDelArduino.split("=")[1];
                _socket.emit("hardware-dice-estado", estado);
            }

            // 2. Si el Arduino manda una medición analógica (ej: "medida:512")
            if( _fraseDelArduino.includes("medida:") ) {
                let _valor = + _fraseDelArduino.slice("medida:".length); // Convierte a número
                let _voltaje = _valor / 1023 * 5.00; // Adaptado para resolución Arduino de 10 bits (0-1023)

                // Enviamos el dato procesado al servidor
                _socket.emit("arduino-dice", "sensor-1", _voltaje);
            }
        }

        // Recibir órdenes desde el Dashboard Web para forzar la placa Arduino
        _socket.on("servidor-envia-accion-placa", function(cmd) {
            let elementoPlaca = document.getElementById("idArduino");
            if(elementoPlaca && typeof elementoPlaca.enviar === "function") {
                elementoPlaca.enviar(cmd);
                document.getElementById("consola").innerText = "Comando inyectado al Arduino: " + cmd;
            }
        });
    </script>
</body>
</html>
