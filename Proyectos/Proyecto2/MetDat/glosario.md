# Glosario de Negocio

**Identificador:** ET-GLOS-001 | **Versión:** 1.0 | **Fecha:** 2026-05-01
**Fuente de verdad:** OpenMetadata - Glosario EnergiTech (Grupo10)
**Marco de referencia:** UNE 0087

Todos los términos están cargados en [OpenMetadata - Grupo10.Glosario](http://172.20.48.127:8585/glossary/%22Grupo10.Glosario%22) con estado **Draft**. La fuente de este documento es el CSV `EnergiTech_Glosario_OpenMetadata_v2.csv`.

---

| ID | Término | Definición | Sinónimos | PII | Ref. Catálogo |
|:---|:---|:---|:---|:---|:---|
| G10-001 | Calendario de Festivos | Información sobre festivos nacionales, autonómicos y locales por zona geográfica. Se usa como variable explicativa en el modelo de previsión para ajustar patrones de consumo. Actualización anual. | Calendario zona; Festivos por zona | No | CT-401 |
| G10-002 | Calidad de Lectura | Indicador que clasifica cada registro de consumo según su origen: REAL (lectura directa), ESTIMADA (calculada por ausencia de lectura) o CORREGIDA (ajustada tras validación). Al menos el 95% de las lecturas deben ser REAL. | Tipo de lectura; Origen del dato | No | CT-201 |
| G10-003 | Cliente Crítico | Cliente cuya interrupción de suministro tendría impacto grave: hospitales, centros de datos, infraestructuras esenciales e industrias con procesos continuos. Tiene SLA reforzado y su previsión de demanda se calcula de forma segregada. | Cliente prioritario; Cliente esencial | PII.Sensitive | CT-101 |
| G10-004 | Cliente Industrial | Persona jurídica con suministro eléctrico para actividad productiva y potencia contratada > 50 kW. Se factura por maxímetro y está sujeto a tarifas de acceso 6.x TD. | Abonado industrial; Gran consumidor | PII.Sensitive | CT-101 |
| G10-005 | Cliente Residencial | Persona física con suministro eléctrico para uso doméstico en vivienda habitual o segunda residencia. Potencia contratada típica ≤ 15 kW. | Cliente doméstico; Abonado residencial | PII.Sensitive | CT-101 |
| G10-006 | Consumo Histórico Horario | Dataset con lecturas horarias de consumo (kWh) de todos los puntos de suministro, registradas por contadores inteligentes y SCADA. Granularidad horaria; se requieren al menos 24 meses de histórico. | Lecturas horarias; Histórico de consumo | PII.Sensitive | CT-201 |
| G10-007 | Consumo Mensual | Energía total consumida por un punto de suministro durante un mes natural, en kWh. Se calcula como diferencia entre lecturas al inicio y fin de mes. Los meses incompletos se proratean. | Consumo periodo; Lectura mensual | PII.Sensitive | CT-201 |
| G10-008 | Dato Meteorológico | Registro de variables atmosféricas (temperatura, humedad, radiación solar, precipitación) obtenido de AEMET. Se usa como variable explicativa en el modelo de previsión. | Dato climático; Variables climáticas | No | CT-301 |
| G10-009 | ETL | Proceso de extracción, transformación y carga de datos desde los sistemas fuente hacia los repositorios analíticos. Incluye limpieza, imputación, normalización y cruce de fuentes. | Pipeline de datos; Flujo ETL | PII.Sensitive | - |
| G10-010 | Informe de Previsión | Documento generado tras la ejecución y validación del modelo predictivo. Incluye valores estimados de demanda, gráficos de tendencia, nivel de confianza y recomendaciones operativas. | Reporte de forecast; Informe de demanda | No | CT-701 |
| G10-011 | MAPE | Error porcentual absoluto medio entre valores previstos y reales. Umbral aceptable en EnergiTech: MAPE ≤ 10%. | Mean Absolute Percentage Error; Error de predicción | No | CT-601 |
| G10-012 | Modelo Predictivo IA/ML | Algoritmo que genera la previsión de demanda energética a partir de consumo histórico, meteorología, calendario y tarifas. Se ejecuta como caja negra desde la perspectiva del proceso de negocio. | Algoritmo de predicción; Motor de forecast | No | CT-601 |
| G10-013 | Potencia Contratada | Potencia máxima (kW) que un cliente puede consumir simultáneamente según su contrato. Condiciona la tarifa aplicable y el dimensionamiento de infraestructura. | Potencia suscrita; Potencia nominal | PII.Sensitive | CT-101 |
| G10-014 | Previsión de Demanda | Estimación cuantificada de la energía que se espera consumir en un horizonte futuro, generada mensualmente por el modelo IA/ML. Debe tener MAPE ≤ 10% para ser válida; se segmenta por tipo de cliente y zona. | Forecast; Predicción de consumo | No | CT-701 |
| G10-015 | Punto de Suministro | Ubicación física de entrega de energía identificada por un CUPS (formato `ES[0-9]{16}[A-Z]{2}`). Un punto de suministro pertenece a exactamente un cliente en un momento dado y es la unidad mínima de medición. | CUPS; Punto de entrega | PII.Sensitive | CT-101 |
| G10-016 | RBAC | Mecanismo de seguridad que restringe el acceso a los datos según el rol del usuario. Roles definidos en EnergiTech: Analista de Demanda, Data Steward, DBA, Operaciones y Dirección. | Role-Based Access Control; Control de acceso | PII.SpecialCategory | - |
| G10-017 | Seudonimización | Técnica de protección de datos que sustituye identificadores directos por códigos reversibles (SHA-256), permitiendo la reidentificación solo con información adicional almacenada por separado. Obligatoria según RGPD antes del uso analítico. | Pseudonymization; Enmascaramiento reversible | PII.SpecialCategory | CT-101 |
| G10-018 | SLA Cliente Crítico | Acuerdo de nivel de servicio para clientes críticos que establece garantías de suministro ininterrumpido, tiempos máximos de respuesta y penalizaciones por incumplimiento. | Service Level Agreement; Garantía de suministro | PII.Sensitive | CT-101 |
| G10-019 | Tarifa Energética | Precio unitario de la energía en el mercado mayorista o regulado (€/MWh), aplicable en un periodo horario concreto. Actualización diaria desde OMIE/REE; influye en la decisión de compra tras la previsión. | Precio pool; Tarifa eléctrica | No | CT-501 |
| G10-020 | Zona Geográfica | Área territorial definida por EnergiTech para agrupar puntos de suministro con características climáticas y operativas similares. Cada punto pertenece a una única zona. Código formato `ZN-[A-Z]{3}-[0-9]{3}`. | Zona de distribución; Área operativa | No | CT-101 |

---

> **Nota:** El término `Hiperparámetro` del borrador inicial (BT-010) no figura en OpenMetadata ni en el CSV exportado. Queda como **[PENDIENTE DE VALIDACIÓN]** con el equipo de Analítica antes de incorporarlo al glosario oficial.