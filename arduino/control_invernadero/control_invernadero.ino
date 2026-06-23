#include <Servo.h>

// Entradas actualizadas según el montaje físico.
const byte PIN_LDR = A0;
const byte PIN_HUMEDAD = A1;

// Salidas actualizadas.
const byte PIN_SERVO = 3;
const byte PIN_LED_HUMEDO = 5;
const byte PIN_LED_SECO = 6;

// Deben ajustarse luego de medir el sensor en tierra seca y húmeda.
// En este montaje una lectura baja representa tierra seca.
const int UMBRAL_SECO = 70;
const int UMBRAL_HUMEDO = 100;
const unsigned long ESPERA_CONFIG_MS = 2000;
const unsigned long INTERVALO_REPORTE_MS = 1000;

const byte SERVO_CONFIG = 180;
const byte SERVO_RIEGO_ABIERTO = 0;
const byte SERVO_RIEGO_CERRADO = 90;

enum Estado {
  CONFIGURACION = 0,
  TIERRA_SECA = 1,
  TIERRA_HUMEDA = 2
};

Servo miMotor;
Estado estado = CONFIGURACION;
unsigned long inicioEstado = 0;
unsigned long ultimoReporte = 0;

void setup() {
  Serial.begin(9600);
  Serial.setTimeout(10);

  pinMode(PIN_LDR, INPUT);
  pinMode(PIN_HUMEDAD, INPUT);
  pinMode(PIN_LED_HUMEDO, OUTPUT);
  pinMode(PIN_LED_SECO, OUTPUT);

  miMotor.attach(PIN_SERVO);
  Serial.println("Conectados y listos");
  cambiarEstado(CONFIGURACION);
}

void loop() {
  leerComando();

  int humedad = analogRead(PIN_HUMEDAD);
  ejecutarEstado(humedad);
  reportarSensores(humedad);

  delay(100);
}

void leerComando() {
  if (!Serial.available()) return;

  String comando = Serial.readString();
  comando.trim();

  if (comando == "e0") cambiarEstado(CONFIGURACION);
  else if (comando == "e1") cambiarEstado(TIERRA_SECA);
  else if (comando == "e2") cambiarEstado(TIERRA_HUMEDA);
}

void ejecutarEstado(int humedad) {
  if (estado == CONFIGURACION) {
    if (millis() - inicioEstado < ESPERA_CONFIG_MS) return;

    if (humedad <= UMBRAL_SECO) cambiarEstado(TIERRA_SECA);
    else cambiarEstado(TIERRA_HUMEDA);
    return;
  }

  // Histéresis: evita cambios continuos cuando la lectura ronda el límite.
  if (estado == TIERRA_SECA && humedad >= UMBRAL_HUMEDO) {
    cambiarEstado(TIERRA_HUMEDA);
  } else if (estado == TIERRA_HUMEDA && humedad <= UMBRAL_SECO) {
    cambiarEstado(TIERRA_SECA);
  }
}

void cambiarEstado(Estado nuevoEstado) {
  estado = nuevoEstado;
  inicioEstado = millis();

  digitalWrite(PIN_LED_SECO, estado == TIERRA_SECA ? HIGH : LOW);
  digitalWrite(PIN_LED_HUMEDO, estado == TIERRA_HUMEDA ? HIGH : LOW);

  if (estado == CONFIGURACION) miMotor.write(SERVO_CONFIG);
  else if (estado == TIERRA_SECA) miMotor.write(SERVO_RIEGO_ABIERTO);
  else miMotor.write(SERVO_RIEGO_CERRADO);

  // Formato que interpreta conectar-hardware.php.
  Serial.print("Estado=");
  Serial.println((int)estado);
}

void reportarSensores(int humedad) {
  if (millis() - ultimoReporte < INTERVALO_REPORTE_MS) return;
  ultimoReporte = millis();

  // El dashboard reconoce la etiqueta "medida:".
  Serial.print("medida:");
  Serial.println(humedad);

  Serial.print("luz:");
  Serial.println(analogRead(PIN_LDR));
}
