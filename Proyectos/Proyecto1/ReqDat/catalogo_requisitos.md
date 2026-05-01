# ReqDat - Catálogo de Requisitos

**Identificador:** ET-CAT-REQ-001 | **Versión:** 1.0
**Proceso asociado:** ET-PN-001 - Cálculo de la Previsión de la Demanda Energética
**Marco de referencia:** UNE 0078

---

## 1. Requisitos de Negocio (RN)

Definen qué espera EnergiTech del sistema predictivo desde el punto de vista del negocio.

| ID | Descripción | Fuente | Prioridad | Trazabilidad BPMN |
|:---|:---|:---|:---|:---|
| RN-01 | La previsión debe cubrir un horizonte mínimo de 3 meses naturales. | Dirección de Operaciones | Crítica | Act. 3, Act. 4 |
| RN-02 | El sistema debe diferenciar clientes críticos (hospitales, industrias clave) del resto. | Dirección de Operaciones | Crítica | Act. 1, Act. 4 |
| RN-03 | El error de predicción (MAPE) no debe superar el 10%. | Dirección de Operaciones | Crítica | Act. 3 |
| RN-04 | El proceso completo (datos → informe) debe completarse en menos de 4 horas. | Analista de Datos | Media | Act. 1-5 |
| RN-05 | El proceso se ejecutará con periodicidad mensual como mínimo. | Dirección de Operaciones | Media | Act. 5 |
| RN-06 | El informe final debe entregarse formalmente con confirmación de recepción. | Dirección de Operaciones | Media | Act. 5 |

---

## 2. Requisitos de Datos (RD)

Especifican qué datos son necesarios, de qué fuentes, en qué formato y con qué restricciones de acceso.

| ID | Dataset | Descripción | Fuente | Formato | Acceso / Seguridad | Prioridad | Trazabilidad BPMN |
|:---|:---|:---|:---|:---|:---|:---|:---|
| RD-01 | `DS-CONSUMO-HIST` | Series temporales horarias/diarias de consumo. Mínimo 24 meses. | SCADA / ERP | CSV | Restringido a analistas; cifrado en reposo | Crítica | Act. 1 |
| RD-02 | `DS-METEO-AEMET` | Temperatura, humedad y radiación solar previstas. Retraso máximo 24h. | AEMET (API REST) | JSON | API key corporativa | Crítica | Act. 1 |
| RD-03 | `DS-CLIENTES-CRM` | Tipo de cliente, zona geográfica, tarifa contratada. Extracción semanal. | CRM corporativo | JSON | Seudonimización obligatoria (RGPD) antes del pipeline | Crítica | Act. 1 |
| RD-04 | `DS-CALENDARIO` | Festivos nacionales y locales por zona geográfica. | BOE (fuente pública) | CSV / JSON | Público | Media | Act. 1 |
| RD-05 | `DS-TARIFAS-OMIE` | Precios de mercado actualizados diariamente. | OMIE / REE (API) | JSON | API key corporativa | Media | Act. 1 |
| RD-06 | Parámetros del modelo | Hiperparámetros y versión activa del modelo IA. | Repositorio de modelos | YAML / JSON | Restringido a analistas y equipo IA | Baja | Act. 3 |

---

## 3. Requisitos de Calidad del Dato (RC)

Umbrales y métricas que deben cumplirse para que los datos sean aptos para el proceso.

| ID | Característica | Métrica / Umbral | Dataset afectado | Actividad de control | Prioridad | Trazabilidad BPMN |
|:---|:---|:---|:---|:---|:---|:---|
| RC-01 | Completitud | ≥ 95% de valores presentes en campos obligatorios | RD-01, RD-03 | Act. 2 - Validación | Alta | Act. 2 |
| RC-02 | Exactitud | Error de lectura ≤ 2% respecto al medidor físico (muestra aleatoria) | RD-01 | Act. 2 - Validación | Alta | Act. 2 |
| RC-03 | Consistencia | 0 conflictos de ID de cliente entre CRM, ERP y SCADA | RD-01, RD-03 | Act. 2 - Validación | Alta | Act. 2 |
| RC-04 | Actualidad | Retraso de datos meteorológicos < 24 horas | RD-02 | Act. 1 - Ingesta | Media | Act. 1 |
| RC-05 | Unicidad | 0 duplicados por clave `(ID_Cliente, Fecha, Punto_Suministro)` | RD-01, RD-03 | Act. 2 - Validación | Alta | Act. 2 |
| RC-06 | Coherencia temporal | Gaps ≤ 48h → interpolación lineal; > 48h → revisión manual | RD-01 | Act. 2 - Validación | Media | Act. 2 |

---

## 4. Requisitos de Seguridad (RS)

Requisitos relacionados con protección de datos, control de acceso y trazabilidad.

| ID | Descripción | Fuente | Prioridad | Trazabilidad BPMN |
|:---|:---|:---|:---|:---|
| RS-01 | Los datos de clientes deben seudonimizarse antes de entrar al pipeline de procesamiento. | RGPD / DPO corporativo | Crítica | Act. 1 |
| RS-02 | El acceso al histórico de consumo y al CRM está restringido a perfiles autorizados, con autenticación y registro de acceso. | Política de seguridad corporativa | Crítica | Act. 1, Act. 2 |
| RS-03 | El informe de previsión se almacena con control de acceso y se envía por canal cifrado (solo Dirección de Operaciones y perfiles autorizados). | Política de seguridad corporativa | Alta | Act. 4, Act. 5 |
| RS-04 | Cada ejecución genera un log de auditoría con: fecha, usuario, versión del modelo, hash de los datasets de entrada y resultado de validación. | UNE 0078 / Trazabilidad | Alta | Act. 3 |
| RS-05 | Las APIs de datos meteorológicos y tarifas se autentican mediante API key corporativa gestionada en el almacén de secretos corporativo. | Política de seguridad TI | Media | Act. 1 |