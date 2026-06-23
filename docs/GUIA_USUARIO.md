# Guía de usuario — Control de Invernadero IoT

## 1. Requisitos

- Windows con PHP 8.4 o posterior, Node.js y npm.
- Google Chrome o Microsoft Edge con soporte para WebSerial.
- Arduino compatible conectado por USB y programado con `arduino/control_invernadero/control_invernadero.ino`.
- Componentes conectados según `docs/CONEXIONES.md`.

## 2. Instalación y puesta en marcha

1. Abrir una terminal en la raíz del repositorio.
2. Iniciar todo el sistema con `.\iniciar.bat`.
3. Abrir `http://localhost:8000` en Google Chrome o Microsoft Edge.

El iniciador levanta automáticamente la aplicación PHP en el puerto 8000 y
Socket.IO en el puerto 3000. La primera vez también instala las dependencias de
Node.js. No hace falta abrir una segunda terminal.

Si Windows indica que no encuentra PHP, instalarlo con
`winget install PHP.PHP.8.4`, cerrar y volver a abrir PowerShell y ejecutar
otra vez `.\iniciar.bat`.

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
| Windows indica que no reconoce PHP | Ejecutar `winget install PHP.PHP.8.4`, volver a abrir PowerShell y ejecutar `.\iniciar.bat`. |
| La página no abre | Confirmar que la terminal muestre `http://localhost:8000` y que el puerto 8000 esté libre. |
| El dashboard no cambia | Cerrar el iniciador con `Ctrl+C`, volver a ejecutar `.\iniciar.bat` y comprobar que el puerto 3000 esté libre. |
| No aparece el puerto USB | Usar Chrome/Edge, revisar el cable y los controladores del Arduino. |
| El puerto está ocupado | Cerrar el monitor serial y otras aplicaciones que usen el puerto. |
| Los valores parecen invertidos | Calibrar `UMBRAL_SECO` y `UMBRAL_HUMEDO` con muestras reales. |
| Los comandos no llegan | Mantener abierta y conectada la pestaña `conectar-hardware.php`. |

## 7. Apagado seguro

Desconectar el componente WebSerial y presionar `Ctrl+C` en la ventana del
iniciador. Esto detiene PHP y Socket.IO. Recién después, retirar el cable USB o
la alimentación externa.
