# **Guía de Usuario: Sistema de Control de Invernadero IoT**

Esta guía contiene los pasos necesarios para instalar, configurar y operar el prototipo de automatización y monitoreo de riego.

## **1\. Requisitos Previos**

Antes de comenzar, asegurarse de contar con los siguientes elementos:

* **Sistema Operativo:** Windows con **Node.js**, **npm** y **PHP 8.4** (o superior) instalados.  
* **Navegador Web:** Google Chrome o Microsoft Edge (requeridos para el soporte de la API *WebSerial*).  
* **Hardware:** Tarjeta Arduino compatible, conectada por USB y previamente programada con el firmware ubicado en arduino/control\_invernadero/control\_invernadero.ino.  
* **Conexiones:** Componentes electrónicos ensamblados según las especificaciones de docs/CONEXIONES.md.

## **2\. Instalación y Puesta en Marcha**

El sistema cuenta con un script de automatización que simplifica el despliegue de los servicios.

1. **Abrir la terminal:** Navegá hasta la raíz del repositorio usando PowerShell o la terminal de tu preferencia.  
2. **Iniciar el sistema:** Ejecutar el comando: “.\\iniciar.bat”  
   *Nota: La primera vez, el script instalará automáticamente las dependencias de Node.js. Luego, levantará la aplicación PHP (puerto 8000\) y el servidor Socket.IO (puerto 3000\) de forma conjunta. No es necesario abrir terminales adicionales.*  
3. **Acceder a la app:** Abrí tu navegador e ingresá a: http://localhost:8000

**ATENCIÓN ¿Windows no reconoce el comando PHP?**

Si la terminal devuelve un error, ejecutar winget install PHP.PHP.8.4. Una vez finalizado, cerrá la terminal, volvé a abrirla en la raíz del proyecto y ejecutar nuevamente .\\iniciar.bat.

## **3\. Control de Acceso (Inicio de Sesión)**

Para ingresar al panel de control, utilizar las siguientes credenciales de prueba:

* **Usuario:** abc  
* **Contraseña:** 1234

**Nota de seguridad:** Estas credenciales están integradas con fines estrictamente académicos. Para un entorno de producción, deben reemplazarse por un sistema de almacenamiento seguro en base de datos y contraseñas encriptadas con funciones de hash.

## **4\. Vinculación del Hardware (Puente WebSerial)**

Para que el panel web pueda comunicarse con el Arduino, es indispensable activar el puente de comunicación:

1. Iniciá sesión en la plataforma.  
2. En el menú principal, seleccioná **Abrir Puente Hardware**.  
3. Dentro del componente de Arduino, presioná el botón **Conectar**.  
4. Seleccioná el puerto COM asignado a tu Arduino en la lista desplegable del navegador y confirmá.  
5. **Importante:** Mantener esta pestaña abierta durante todo el tiempo que utilices el dashboard.

**Restricción de puerto:** Asegurarse de cerrar el Monitor Serie del IDE de Arduino (o cualquier otro software de telemetría) antes de conectar. El puerto serial es de acceso exclusivo y no puede ser compartido por dos aplicaciones en simultáneo. El navegador exige además un origen seguro (localhost o protocolo HTTPS).

## **5\. Operación del Dashboard**

Una vez vinculado el hardware, tendrás acceso a las siguientes lecturas y controles en tiempo real:

### **Monitoreo**

* **Medida del sensor:** Muestra la lectura actual de humedad en el suelo, convertida del valor bruto (0–1023) a escala de tensión (0–5 V).  
* **Estado de la MEF:** Visualiza el estado activo de la Máquina de Estados Finitos (Configuración, Tierra Seca o Tierra Húmeda).

### **Controles Manuales (Modo Demostración)**

* **Forzar Config (e0):** Pone al controlador en estado de configuración/espera.  
* **Forzar Seco (e1):** Abre de forma forzada el mecanismo de riego y simula la alerta de suelo seco.  
* **Forzar Húmedo (e2):** Cierra el mecanismo de riego y simula el estado de suelo hidratado.

**Cerrar sesión:** Finaliza la sesión de PHP de forma segura, bloqueando inmediatamente el acceso al puente de hardware a usuarios no autenticados.

## **6\. Resolución de Problemas Frecuentes**

| Síntoma / Problema | Causa Probable | Acción Correctiva |
| :---- | :---- | :---- |
| **"PHP no se reconoce como un comando..."** | PHP no está instalado o no se encuentra en las variables de entorno. | Ejecutá winget install PHP.PHP.8.4, reiniciá la terminal de PowerShell y reintentá el inicio. |
| **La página web no carga (HTTP 404 / Rechazado)** | El servidor web local no inició correctamente. | Verificá en la terminal que se muestre la dirección del servidor y que el puerto 8000 no esté siendo usado por otra app. |
| **El dashboard se congela o no actualiza los datos** | Error en el servidor de eventos en tiempo real. | Cerrá el proceso actual en la terminal (Ctrl \+ C), asegurate de tener libre el puerto 3000 y relanzá .\\iniciar.bat. |
| **No figura la placa Arduino en la lista de puertos** | Problema de conexión física o navegador incompatible. | Asegurate de usar Chrome/Edge. Revisá el cable USB y los controladores (drivers) de la placa. |
| **Error: Puerto bloqueado u ocupado** | Conflicto de software por el acceso al puerto COM. | Cerrá el Monitor Serie del IDE de Arduino y cualquier otra aplicación de control industrial o comunicación serial. |
| **Los valores de humedad se leen de forma invertida** | Falta de calibración en el entorno real. | Ajustá las variables UMBRAL\_SECO y UMBRAL\_HUMEDO en el código del Arduino según las muestras de tu suelo. |
| **Los comandos de control manual no surten efecto** | Desconexión en el canal de retransmisión web. | Asegurate de que la pestaña conectar-hardware.php permanezca abierta y con el estado "Conectado". |

## 

## 

## **7\. Apagado Seguro del Sistema**

Para finalizar la sesión de trabajo sin corromper procesos, seguir este orden:

1. Desconectar el puerto desde el componente *WebSerial* en el navegador.  
2. Dirigirse a la ventana de la terminal donde corre el script y presionar **Ctrl \+ C** para detener en limpio los servidores PHP y Socket.IO.  
3. Una vez cerrados los servicios de software, puede retirar con seguridad el cable USB del Arduino o desconectar su fuente de alimentación.

