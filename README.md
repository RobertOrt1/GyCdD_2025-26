# GyCdD_2025-26
# Proyecto 1: Procesamiento del Dato y Gestión de Requisitos - EnergiTech

Este repositorio contiene la documentación técnica y los artefactos del **Proyecto 1** de la iniciativa de Gobierno de Datos de EnergiTech, desarrollado bajo el marco de la especificación **UNE 0078**.

## 1. Resumen del Proceso de Negocio (ProcDat)
Se ha modelado el flujo operativo para la **Previsión de la Demanda Energética**. El objetivo es estandarizar cómo los analistas interactúan con las herramientas de IA para generar predicciones fiables para clientes críticos.

### Flujo de Trabajo Principal
1.  **Captura (Ingesta):** Obtención de históricos de consumo, datos de CRM y previsiones meteorológicas.
2.  **Validación:** Control de calidad preventivo (limpieza y normalización).
3.  **Cálculo:** Ejecución del modelo predictivo (IA/ML).
4.  **Resultados:** Generación de informes de demanda y logs técnicos de ejecución.
5.  **Comunicación:** Entrega formal de previsiones a la Dirección de Operaciones.

---

## 2. Catálogo Completo de Requisitos (ReqDat)
A continuación se detallan todos los requisitos identificados, validados y priorizados para el éxito del proyecto.

### 2.1. Requisitos de Negocio (RN)
| ID | Requisito | Criterio de Aceptación | Prioridad |
| :--- | :--- | :--- | :--- |
| **RN-01** | Horizonte ≥ 3 meses | El informe debe cubrir los próximos 3 meses naturales. | Crítica |
| **RN-02** | Segmentación Crítica | Diferenciación clara de hospitales e industrias clave. | Crítica |
| **RN-03** | Precisión (MAPE) | El error porcentual medio no debe superar el **10%**. | Crítica |
| **RN-04** | Tiempo de Ejecución | Proceso completo (Datos -> Informe) en **< 4 horas**. | Media |
| **RN-05** | Periodicidad Mensual | Actualización obligatoria al menos una vez al mes. | Media |

### 2.2. Requisitos de Datos (RD)
| ID | Dato / Dataset | Requisito Técnico | Prioridad |
| :--- | :--- | :--- | :--- |
| **RD-01** | Consumo Histórico | Mínimo **24 meses** de datos (horarios/diarios). | Crítica |
| **RD-02** | Meteorología | Datos de AEMET (Temp, Humedad, Radiación) en JSON. | Crítica |
| **RD-03** | Datos de Clientes | Extracción semanal del CRM; **Seudonimización RGPD**. | Crítica |
| **RD-04** | Calendario | Festivos nacionales y locales por zona geográfica. | Media |
| **RD-05** | Tarifas | Precios de mercado (OMIE/REE) actualizados diariamente. | Media |
| **RD-06** | Parámetros Modelo | Documentación de hiperparámetros y versión del modelo. | Baja |

### 2.3. Requisitos de Calidad de Datos (RC)
| ID | Característica | Métrica / Umbral | Prioridad |
| :--- | :--- | :--- | :--- |
| **RC-01** | Completitud | **≥ 95%** de valores presentes en campos obligatorios. | Alta |
| **RC-02** | Exactitud | Margen de error **≤ 2%** respecto a lecturas reales. | Alta |
| **RC-03** | Consistencia | **0 conflictos** de ID de cliente entre CRM, ERP y SCADA. | Alta |
| **RC-04** | Actualidad | Retraso de datos meteorológicos **< 24 horas**. | Media |
| **RC-05** | Unicidad | **0 duplicados** por (ID_Cliente, Fecha, Punto_Suministro). | Alta |
| **RC-06** | Coherencia | No más de 48h de huecos (gaps) en series temporales. | Media |

---

## 3. Gestión de la Configuración (ConfDat)
Para garantizar la trazabilidad y la integridad de la iniciativa, se han versionado los siguientes artefactos:

* **ET-PN-001 (v1.0):** Documento de Proceso de Negocio (Aprobado).
* **ET-PN-001-BPMN (v1.0):** Diagrama de flujo en formato SVG/VPP (Aprobado).
* **ET-CAT-REQ-001 (v1.0):** Catálogo de Requisitos en Excel (En revisión).
* **ET-MOD-PRED-001 (v0.1-beta):** Script y pesos del modelo de IA (En desarrollo).

---
**EnergiTech - Iniciativa de Gobierno de Datos 2026**
