# Control de Invernadero IoT

Proyecto académico que integra Arduino, WebSerial, Socket.IO y PHP para medir
humedad de suelo, visualizar una máquina de estados finitos y enviar comandos
al hardware desde un dashboard protegido por sesión.

## Ejecución

```powershell
npm install
node server.js
```

En otra terminal:

```powershell
php -S 127.0.0.1:8000
```

Abrir `http://127.0.0.1:8000/index.php`. Las credenciales académicas son
`abc` / `1234`.

## Documentación

- [Informe completo](docs/Informe-Control-Invernadero.docx)
- [Informe en PDF](docs/Informe-Control-Invernadero.pdf)
- [Guía de usuario](docs/GUIA_USUARIO.md)
- [Conexiones y calibración](docs/CONEXIONES.md)
- [Diagramas](docs/DIAGRAMAS.md)
- [Checklist de entrega](docs/CHECKLIST_ENTREGA.md)
- [Firmware Arduino](arduino/control_invernadero/control_invernadero.ino)

Antes de entregar, completar los nombres de integrantes y agregar fotografías
reales del prototipo en el anexo del informe.
