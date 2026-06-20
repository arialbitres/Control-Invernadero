# Conexiones y calibración

## Tabla de conexiones propuesta

| Componente | Arduino Uno | Alimentación | Función |
|---|---:|---|---|
| Sensor de humedad de suelo | A0 | 5 V / GND | Medición principal de humedad. |
| Módulo LDR | A1 | 5 V / GND | Medición de luz para ampliación futura. |
| Servomotor SG90 | D9 (señal) | Fuente externa de 5 V | Apertura/cierre del mecanismo de riego. |
| LED rojo + resistencia 220 Ω | D6 | GND | Indicación de tierra seca. |
| LED verde + resistencia 220 Ω | D7 | GND | Indicación de tierra húmeda. |
| Buzzer | D5 | GND | Aviso breve al ingresar al estado seco. |

## Reglas eléctricas

- Unir el GND de la fuente externa del servo con el GND del Arduino.
- No alimentar una electroválvula o bomba directamente desde un pin del Arduino.
- Si se reemplaza el servo por una bomba, usar módulo relé o MOSFET, diodo de protección y fuente adecuada.
- Verificar el consumo del servo; una fuente externa de 5 V evita reinicios del microcontrolador.

## Calibración del sensor

1. Medir el valor con el sensor al aire o en tierra completamente seca.
2. Medir el valor en tierra con la humedad objetivo.
3. Ajustar `UMBRAL_SECO` y `UMBRAL_HUMEDO` en el archivo `.ino`.
4. Mantener dos umbrales separados para evitar cambios rápidos de estado cerca del límite (histéresis).

Los valores `650` y `500` incluidos en el firmware son iniciales y no sustituyen una calibración física.
