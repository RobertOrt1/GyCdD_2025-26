# GyCdD_2025-26
## Proyecto 1: Procesamiento del Dato y Gestión de Requisitos - EnergiTech

Este proyecto detalla la fase inicial de la iniciativa de gestión de datos para el sistema de análisis predictivo de demanda energética de **EnergiTech**, centrándose en satisfacer las necesidades de los clientes críticos.

### 1. Descripción del Proceso de Negocio: Previsión de la Demanda (ProcDat)
Siguiendo la especificación **UNE 0078 (N1)**, se ha modelado el proceso mediante el cual un trabajador de EnergiTech realiza el cálculo de previsión de demanda.

#### Etapas del Procesamiento (ProcDat.T1)
El flujo de trabajo operativo se divide en las siguientes etapas exploratorias:

1.  **Captura de Datos:** Recopilación de históricos de consumo de los tres sistemas de gestión actuales (Luz, Gas, Mantenimiento) y variables meteorológicas externas.
    * **Datos:** `ID_Cliente`, `Histórico_kWh`, `Temp_Prevista`, `Humedad`.
2.  **Validación de Datos:** Verificación de la integridad de los ficheros y limpieza de registros inconsistentes para asegurar que la "función de cálculo" no falle.
    * **Datos:** Logs de carga, comprobación de registros nulos y formatos de fecha.
3.  **Cálculo (Procesamiento):** El trabajador ejecuta la función de análisis predictivo basada en IA introduciendo los datos validados del paso anterior.
    * **Datos:** Parámetros del modelo e inputs refinados de consumo y clima.
4.  **Generación de Resultados (ProcDat.T2):** Obtención del producto de datos final para el negocio y sus evidencias.
    * **Datos:** `Informe de Previsión Semanal` (PDF/Excel) y `Logs de ejecución`.
5.  **Comunicación:** Envío de los resultados a los responsables de distribución para garantizar el suministro.

> **Nota de Modelado:** Se ha utilizado la notación **BPMN** (vía Visual Paradigm) para representar gráficamente estas instrucciones de procesamiento.

---

### 2. Identificación de Requisitos de Datos (ReqDat)
Aplicando la especificación **UNE 0078 (N2)**, se han definido las condiciones que deben cumplir los datos para el análisis predictivo.

#### Fuentes de Requisitos (ReqDat.T1)
* **Negocio:** Responsables de operaciones de EnergiTech.
* **Técnica:** Administradores de los sistemas de Luz, Gas y Mantenimiento.
* **Normativa:** Regulaciones del sector eléctrico y leyes de protección de datos (RGPD).

#### Catálogo de Requisitos del Dato (ReqDat.T2)
| ID | Categoría | Descripción | Prioridad |
| :--- | :--- | :--- | :--- |
| **RD-01** | Negocio | La previsión debe cubrir un horizonte temporal de 7 días. | Alta |
| **RD-02** | Datos | Uso obligatorio de datos históricos de los últimos 5 años. | Alta |
| **RD-03** | Calidad | **Completitud:** Los registros de consumo no deben tener más de un 1% de valores nulos. | Crítica |
| **RD-04** | Formato | Integración de datos meteorológicos externos en formato JSON estructurado. | Media |
| **RD-05** | Seguridad | Control de acceso basado en roles (RBAC) para visualizar datos de clientes críticos. | Crítica |

---

### 3. Trazabilidad y Gestión de Configuración

#### Matriz de Trazabilidad (ReqDat.T3)
Vinculación de los requisitos con las etapas del proceso de negocio:

| ID Requisito | Fuente | Actividad del Proceso (BPMN) | Estado |
| :--- | :--- | :--- | :--- |
| **RD-03** | Técnica | Validación de Datos | Implantado |
| **RD-05** | Normativa | Captura / Almacenamiento | Definido |

#### Control de Versiones (Gestión de Configuración)
Para mantener la integridad de los artefactos generados, se definen las siguientes versiones de trabajo:

| Artefacto | Versión | Responsable | Fecha |
| :--- | :--- | :--- | :--- |
| **Modelo_BPMN_EnergiTech.vpp** | v1.0 | Equipo de Procesos | 2026-04-21 |
| **Plantilla_Requisitos_EnergiTech.xlsx** | v1.1 | Data Steward | 2026-04-21 |
| **Documentación_README.md** | v1.0 | Gestión de Proyecto | 2026-04-21 |

---
**MUBDCN - UCLM** | *Gobierno y Gestión del Dato*
