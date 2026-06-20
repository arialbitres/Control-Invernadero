# Guía de usuario — Control de Invernadero IoT

## 1. Requisitos

- Windows con PHP 8.4 o posterior, Node.js y npm.
- Google Chrome o Microsoft Edge con soporte para WebSerial.
- Arduino compatible conectado por USB y programado con `arduino/control_invernadero/control_invernadero.ino`.
- Componentes conectados según `docs/CONEXIONES.md`.

## 2. Instalación

1. Abrir una terminal en la raíz del repositorio.
2. Ejecutar `npm install` para instalar Socket.IO y Express.
3. Iniciar el servidor de tiempo real con `node server.js`.
4. En otra terminal, iniciar PHP con `php -S 127.0.0.1:8000`.
5. Abrir `http://127.0.0.1:8000/index.php`.

## 3. Inicio de sesión

- Usuario de demostración: `abc`
- Contraseña de demostración: `1234`

Estas credenciales están incorporadas únicamente con fines académicos. En una versión productiva deben reemplazarse por usuarios almacenados de forma segura y contraseñas con hash.

## 4. Conexión del Arduino

1. Iniciar sesión.
2. Elegir **Abrir Puente Hardware**.
3. Presionar **Conectar** dentro del componente Arduino.
4. Seleccionar el puerto USB correspondiente y aceptar.
5. Mantener abierta la pestaña del puente mientras se utiliza el dashboard.

El navegador debe ejecutarse en `localhost` o en un origen HTTPS. Cerrar el monitor serial del IDE de Arduino antes de conectar, ya que un puerto serial no puede ser utilizado por dos aplicaciones simultáneamente.

## 5. Uso del dashboard

- **Medida del sensor:** muestra la lectura de humedad convertida de 0–1023 a 0–5 V.
- **Estado de la MEF:** indica configuración, tierra seca o tierra húmeda.
- **Forzar Config (e0):** lleva el controlador al estado de configuración.
- **Forzar Seco (e1):** abre el mecanismo de riego y activa la señal de suelo seco.
- **Forzar Húmedo (e2):** cierra el mecanismo de riego y activa la señal de suelo húmedo.
- **Cerrar sesión:** finaliza la sesión PHP e impide acceder al puente sin autenticación.

## 6. Solución de problemas

| Problema | Verificación |
|---|---|
| El dashboard no cambia | Confirmar que `server.js` esté activo en el puerto 3000. |
| No aparece el puerto USB | Usar Chrome/Edge, revisar el cable y los controladores del Arduino. |
| El puerto está ocupado | Cerrar el monitor serial y otras aplicaciones que usen el puerto. |
| Los valores parecen invertidos | Calibrar `UMBRAL_SECO` y `UMBRAL_HUMEDO` con muestras reales. |
| Los comandos no llegan | Mantener abierta y conectada la pestaña `conectar-hardware.php`. |

## 7. Apagado seguro

Desconectar el componente WebSerial, detener los servidores con `Ctrl+C` y recién después retirar el cable USB o la alimentación externa.
