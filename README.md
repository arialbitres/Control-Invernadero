# Control de Invernadero IoT

Proyecto académico que integra Arduino, WebSerial, Socket.IO y PHP para medir
humedad de suelo, visualizar una máquina de estados finitos y enviar comandos
al hardware desde un dashboard protegido por sesión.

## Ejecución

Para iniciar todo el sistema:

```powershell
.\iniciar.bat
```

Abrir `http://localhost:8000`. Las credenciales académicas son `abc` / `1234`.
El comando inicia la aplicación PHP y el servidor de comunicación. Para detener
ambos, presionar `Ctrl+C`. La primera vez también instala automáticamente las
dependencias de Node.js.

### Si aparece "php no se reconoce"

PHP no está instalado o no figura en el `PATH` de Windows. Instalarlo con:

```powershell
winget install PHP.PHP.8.4
```

Después, cerrar y volver a abrir PowerShell y ejecutar `.\iniciar.bat`.

Importante: una dirección como `[localhost:8000](http://localhost:8000)` es un
enlace Markdown y no forma parte de un comando de PowerShell.

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
