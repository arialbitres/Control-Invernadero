const express = require('express');
const http = require('http');
const { Server } = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
    cors: { origin: "*" }
});

io.on('connection', (socket) => {
    console.log('Nodo de comunicación enlazado.');

    // Recibe los Volts calculados desde conectar-hardware.php y se los manda al Dashboard
    socket.on('arduino-dice', (canal, voltaje) => {
        io.emit('servidor-dice:lectura-sensor-1', voltaje);
    });

    // Recibe los cambios de estados de la MEF del hardware y se los avisa al Dashboard
    socket.on('hardware-dice-estado', (estado) => {
        io.emit('servidor-dice:cambio-estado', estado);
    });

    // Recibe clicks del dashboard para enviarlos hacia el puente WebSerial
    socket.on('comando-desde-dashboard', (cmd) => {
        io.emit('servidor-envia-accion-placa', cmd);
    });
});

server.listen(3000, () => {
    console.log('==================================================');
    console.log('Servidor de Relevo WebSockets en puerto 3000 activo');
    console.log('==================================================');
});
