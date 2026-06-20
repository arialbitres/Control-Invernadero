#include <Servo.h>

// Entradas
const byte PIN_HUMEDAD = A0;
const byte PIN_LUZ = A1;

// Salidas
const byte PIN_SERVO = 9;
const byte PIN_LED_SECO = 6;
const byte PIN_LED_HUMEDO = 7;
const byte PIN_BUZZER = 5;

// Estos valores deben calibrarse con la tierra y el sensor reales.
const int UMBRAL_SECO = 650;
const int UMBRAL_HUMEDO = 500;
const unsigned long INTERVALO_REPORTE_MS = 1000;

enum Estado {
  CONFIGURACION = 0,
  TIERRA_SECA = 1,
  TIERRA_HUMEDA = 2
};

Servo valvula;
String frasePC;
Estado estado = CONFIGURACION;
unsigned long tiempoEstado = 0;
unsigned long ultimoReporte = 0;

void setup() {
  Serial.begin(9600);
  Serial.setTimeout(10);

  pinMode(PIN_HUMEDAD, INPUT);
  pinMode(PIN_LUZ, INPUT);
  pinMode(PIN_LED_SECO, OUTPUT);
  pinMode(PIN_LED_HUMEDO, OUTPUT);
  pinMode(PIN_BUZZER, OUTPUT);
  valvula.attach(PIN_SERVO);

  Serial.println("Conectados");
  cambiarEstado(CONFIGURACION);
}

void loop() {
  leerComandos();

  int humedad = analogRead(PIN_HUMEDAD);
  if (estado == CONFIGURACION) ejecutarConfiguracion(humedad);
  if (estado == TIERRA_SECA) ejecutarTierraSeca(humedad);
  if (estado == TIERRA_HUMEDA) ejecutarTierraHumeda(humedad);

  reportarSensores(humedad);
  delay(100);
  tiempoEstado += 100;
}

void leerComandos() {
  if (!Serial.available()) return;

  frasePC = Serial.readString();
  frasePC.trim();

  if (frasePC == "e0") cambiarEstado(CONFIGURACION);
  if (frasePC == "e1") cambiarEstado(TIERRA_SECA);
  if (frasePC == "e2") cambiarEstado(TIERRA_HUMEDA);
}

void ejecutarConfiguracion(int humedad) {
  // Espera breve para estabilizar el sensor y luego decide el estado inicial.
  if (tiempoEstado < 2000) return;
  if (humedad >= UMBRAL_SECO) cambiarEstado(TIERRA_SECA);
  else cambiarEstado(TIERRA_HUMEDA);
}

void ejecutarTierraSeca(int humedad) {
  // Histéresis: el riego se detiene recién al alcanzar el umbral húmedo.
  if (humedad <= UMBRAL_HUMEDO) cambiarEstado(TIERRA_HUMEDA);
}

void ejecutarTierraHumeda(int humedad) {
  // El riego vuelve a activarse recién al superar el umbral seco.
  if (humedad >= UMBRAL_SECO) cambiarEstado(TIERRA_SECA);
}

void cambiarEstado(Estado nuevoEstado) {
  estado = nuevoEstado;
  tiempoEstado = 0;

  digitalWrite(PIN_LED_SECO, estado == TIERRA_SECA ? HIGH : LOW);
  digitalWrite(PIN_LED_HUMEDO, estado == TIERRA_HUMEDA ? HIGH : LOW);

  if (estado == CONFIGURACION) {
    valvula.write(0);
    noTone(PIN_BUZZER);
  }

  if (estado == TIERRA_SECA) {
    valvula.write(90); // Abre el mecanismo de riego.
    tone(PIN_BUZZER, 1200, 200);
  }

  if (estado == TIERRA_HUMEDA) {
    valvula.write(0); // Cierra el mecanismo de riego.
    noTone(PIN_BUZZER);
  }

  // Formato compatible con conectar-hardware.php.
  Serial.print("Estado=");
  Serial.println((int) estado);
}

void reportarSensores(int humedad) {
  if (millis() - ultimoReporte < INTERVALO_REPORTE_MS) return;
  ultimoReporte = millis();

  Serial.print("medida:");
  Serial.println(humedad);

  // Canal preparado para una futura ampliación del dashboard.
  Serial.print("luz:");
  Serial.println(analogRead(PIN_LUZ));
}
