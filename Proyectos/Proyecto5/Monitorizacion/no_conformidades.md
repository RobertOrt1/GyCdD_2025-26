# No Conformidades y Lecciónes Aprendidas

**Identificador:** ET-CTRL-NC-001 | **Versión:** 1.0 | **Fecha:** 2026-05-02
**Marco de referencia:** UNE 0079 - CtrlDQ.T4
**Proceso asociado:** ET-PN-001 - Previsión de la Demanda Energetica

---

## 1. Registro de no conformidades (CtrlDQ.T4)

| ID | No conformidad | Causa raíz identificada | Acción correctora | Estado |
| :--- | :--- | :--- | :--- | :--- |
| NC-001 | M-COM-02 al 70% | El proceso de alta de clientes en CRM no valida la presencia de DNI y email antes de sincronizar con el MDM | Añadir validación obligatoria de `id_nacional` y `email_verificado` en el formulario de alta del CRM | Pendiente |
| NC-002 | M-ACC-01 al 92,31% | El sistema SCADA no filtra lecturas fuera de rango antes de publicarlas en la tabla de consumo horario | Implementar el control TV-02 en la fase de ingesta para marcar automaticamente lecturas anómalas antes de persistir | Pendiente |

---

## 2. Detalle de NC-001 - Completitud de registros

**Evidencia:** 3 de los 10 clientes del golden record tienen `id_nacional` o `email_verificado` con valor NULL. Esto impide que el motor MDM aplique las reglas RM-01 y RM-02, lo que bloquea la reconciliacion de identidades con los sistemas fuente.

**Sistema de origen afectado:** CRM Salesforce.

**Impacto en el proceso:** los tres registros afectados no pueden participar en la agregacion de consumos por cliente, lo que subestima la demanda real en los segmentos correspondientes.

**Acción correctora detallada:**
1. Añadir campo obligatorio `DNI/NIE` en el formulario de alta de CRM con validación de formato.
2. Añadir campo obligatorio `email` con verificacion de dominio en el mismo formulario.
3. Ejecutar proceso de backfill sobre los 3 registros existentes: contactar con cada cliente por correo postal para obtener el dato faltante.
4. Programar una re-ejecución de M-COM-02 tras el backfill para verificar la recuperación.

---

## 3. Detalle de NC-002 - Exactitud del rango de consumo

**Evidencia:** 2 lecturas anómalas detectadas - un pico de 9.999 kWh (probable error de sensor) y un consumo negativo (probable error de transmision). Las dos lecturas afectan al cálculo de la media histórica del punto de suministro correspondiente.

**Sistema de origen afectado:** SCADA.

**Impacto en el proceso:** las lecturas anómalas distorsionan la serie temporal de consumo, lo que puede degradar la exactitud del modelo predictivo en las zonas afectadas.

**Acción correctora detallada:**
1. Activar el control TV-02 del pipeline ETL para detectar y marcar como `ESTIMADA` cualquier lectura fuera del rango `[0, 3 * media_histórica]` durante la fase de ingesta.
2. Corregir manualmente las 2 lecturas anómalas existentes: actualizar `calidad_lectura = 'CORREGIDA'` y sustituir el valor por el interpolado lineal entre las lecturas adyacentes.
3. Escalar la lectura de 9.999 kWh al equipo técnico de SCADA para inspeccion del sensor.
4. Programar una re-ejecución de M-ACC-01 tras la corrección para verificar la recuperación.

---

## 4. Lección aprendida

Los problemas de calidad detectados en el Proyecto 4 tienen su causa raíz en los sistemas de origen (CRM y SCADA), no en el pipeline analítico. Las correcciónes aplicadas directamente sobre la BD Grupo10 serian parches temporales; la mejora sostenida requiere actuar en el perímetro de ingesta, donde los datos entran por primera vez en el ecosistema de EnergiTech. Este principio es coherente con el control TV-01 del ciclo de vida definido en el Proyecto 2: la calidad se garantiza en origen, no en destino.