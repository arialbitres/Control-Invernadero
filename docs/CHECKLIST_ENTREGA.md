# Checklist previo a la entrega

## Datos del grupo

- [ ] Reemplazar `[COMPLETAR NOMBRES Y APELLIDOS]` en el informe fuente.
- [ ] Reemplazar el texto del encabezado en `tools/generar_informe_docx.ps1`.
- [ ] Volver a ejecutar el generador del DOCX/PDF.

## Evidencia física

- [ ] Agregar fotografía general del prototipo.
- [ ] Agregar fotografía clara de las conexiones.
- [ ] Agregar captura del monitor serial.
- [ ] Agregar captura del dashboard con datos reales.
- [ ] Calibrar y registrar los umbrales seco/húmedo.

## Presupuesto

- [ ] Actualizar los precios estimativos con proveedores consultados.
- [ ] Incorporar fecha, enlaces o comprobantes de las cotizaciones.

## Prueba técnica

- [ ] Cargar el firmware en el Arduino.
- [ ] Confirmar que el servo tenga alimentación externa y GND común.
- [ ] Verificar los tres estados automáticos.
- [ ] Probar los comandos `e0`, `e1` y `e2` desde el dashboard.
- [ ] Probar login, logout y bloqueo del puente sin sesión.
- [ ] Iniciar el sistema con `.\iniciar.bat` y abrir `http://localhost:8000`.
- [ ] Confirmar que PHP use el puerto 8000 y Socket.IO el puerto 3000.

## Regeneración del informe

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\generar_informe_docx.ps1
```
