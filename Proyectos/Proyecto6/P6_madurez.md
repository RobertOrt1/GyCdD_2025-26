# Proyecto 6 - Evaluación de Madurez con UNE 0080

**Identificador:** ET-MAD-001 | **Versión:** 1.0 | **Fecha:** 2026-05-02
**Marco de referencia:** UNE 0080 - MAMD (basado en ISO/IEC 33000)
**Proceso asociado:** ET-PN-001 - Previsión de la Demanda Energética

---

## 1. Contexto

A lo largo de los seis proyectos de la práctica transversal, EnergiTech ha diseñado, implantado y ejecutado procesos de gestión del dato, metadatos, datos maestros y calidad del dato siguiendo las especificaciones UNE 0078, UNE 0087 y UNE 0079. Este proyecto aplica el modelo de madurez MAMD de UNE 0080 para determinar en qué nivel se encuentra la organización y qué tendría que hacer para subir al siguiente.

La evaluación es de carácter exploratorio y autoevaluativo, basada en las evidencias generadas durante la práctica transversal.

---

## 2. Autoevaluación del nivel de madurez (Tarea 1)

### 2.1 Modelo de referencia

UNE 0080 define cinco niveles de madurez organizacional (MAMD), cada uno condicionado a que los procesos de los niveles anteriores estén completamente implementados (F - Fully Implemented):

| Nivel | Nombre | Condición |
|:---|:---|:---|
| 0 | Incompleto | El proceso no está implementado o falla al ejecutarse |
| 1 | Realizado | Todos los procesos de NM1 con calificación F |
| 2 | Gestionado | Todos los de NM1 con F + los de NM2 con al menos L |
| 3 | Establecido | NM1 y NM2 con F + los de NM3 con al menos L |
| 4 | Predecible | NM1, NM2 y NM3 con F + los de NM4 con al menos L |
| 5 | En Innovación | NM1 a NM4 con F + los de NM5 con al menos L |

### 2.2 Evidencias por proceso

#### Procesos de Gestión del Dato (UNE 0078)

**ProcDat - Procesamiento del dato (Proyecto 1)**
Se modeló el proceso de negocio ET-PN-001 en BPMN con cinco actividades, datasets identificados por nombre, criterios de validación y actores definidos. Se elaboró un catálogo de requisitos (ReqDat) con 20 entradas en cuatro categorías y trazabilidad con el BPMN. Se aplicó gestión de configuración sobre los artefactos generados.
*Calificación: F - el proceso produce sus outputs definidos de forma documentada y trazable.*

**MetDat - Gestión de metadatos (Proyecto 2)**
Se crearon los tres repositorios de metadatos exigidos por UNE 0087: glosario de negocio (20 términos en OpenMetadata), catálogo de datos (7 activos CT-101 a CT-701) y diccionario de datos (DT-101 a DT-701). Se estableció la trazabilidad cruzada entre los tres niveles y se documentó el ciclo de vida del dato con la arquitectura medallón Bronze/Silver/Gold y seis políticas de gobierno.
*Calificación: L - el proceso está ampliamente implementado; pendiente la aprobación de los términos del glosario en OpenMetadata (Draft → Approved) y la ingesta del catálogo en la plataforma.*

**MDM - Gestión de datos maestros (Proyecto 3)**
Se especificó el registro maestro de la entidad Cliente con reglas de matching (RM-01 a RM-03), matriz de autoridad por atributo y estilo arquitectónico de consolidación justificado. Se diseñó el modelo conceptual, lógico y físico, y se crearon las tablas en MySQL (BD Grupo10, servidor Spartan) mediante DDL ejecutado. Se documentó la arquitectura completa con diagrama Mermaid.
*Calificación: L - el modelo está diseñado e implementado en base de datos; el proceso de matching real con los sistemas fuente (CRM, SAP-ISU, ERP) no está automatizado en esta fase exploratoria.*

#### Procesos de Gestión de la Calidad del Dato (UNE 0079)

**PlanDQ - Planificación de la calidad del dato (Proyecto 4)**
Se seleccionaron tres características de calidad de UNE 0081 (Completitud, Consistencia, Exactitud) justificadas frente a los requisitos del negocio. Se definieron seis medidas (M-COM-01/02, M-CON-01/02, M-ACC-01/02) con sus propiedades medibles, fórmulas, umbrales alineados al apetito de riesgo y SQL ejecutable. Los resultados reales se obtuvieron contra datos de prueba en Spartan.
*Calificación: F - el proceso planifica y define las medidas de calidad de forma completa y ejecutable.*

**CtrlDQ - Control y monitorización de la calidad del dato (Proyecto 5)**
Se definieron seis procedimientos de medición (PROC-COM/CON/ACC) con responsable, frecuencia, herramienta, umbral y plan de acción ante no conformidad. Se identificaron dos no conformidades reales (NC-001 y NC-002) con causa raíz y acciones correctoras. Se elaboró un cuadro de mandos con el estado de las seis medidas y se documentó el soporte en OpenMetadata.
*Calificación: L - los procedimientos están definidos y se han ejecutado manualmente; la automatización en OpenMetadata está pendiente de la ingesta de Grupo10.*

### 2.3 Nivel de madurez derivado

| Proceso | NM requerido | Calificación | Cumple |
|:---|:---|:---|:---|
| ProcDat (UNE 0078) | NM1 | F | ✅ |
| MetDat (UNE 0078) | NM1 | L | ⚠️ Parcial |
| MDM (UNE 0078) | NM1 | L | ⚠️ Parcial |
| PlanDQ (UNE 0079) | NM1 | F | ✅ |
| CtrlDQ (UNE 0079) | NM1 | L | ⚠️ Parcial |

Para alcanzar el **Nivel 1 - Realizado**, todos los procesos de NM1 deben tener calificación F. En la evaluación actual, ProcDat y PlanDQ lo cumplen, pero MetDat, MDM y CtrlDQ están en L (ampliamente implementados pero no completamente).

**Nivel de madurez de EnergiTech: entre nivel 0 y nivel 1 - en transición hacia Realizado.**

Justificación: los procesos están diseñados, documentados y parcialmente ejecutados con resultados reales medibles. Sin embargo, la automatización de los procedimientos, la aprobación formal del glosario en OpenMetadata y la integración real del MDM con los sistemas fuente son los elementos que impiden calificar todos los procesos con F.

---

## 3. Plan de mejora (Tarea 2)

### 3.1 ¿Es suficiente el nivel actual?

Para una multinacional del sector energético que distribuye suministro a clientes críticos (hospitales, centros de datos, residencias), el nivel actual no es suficiente. EnergiTech necesita garantías de continuidad de suministro que requieren datos fiables, procesos reproducibles y monitorización automatizada. El nivel 1 sería el mínimo operativo aceptable; el nivel 2 sería el objetivo realista a corto plazo.

### 3.2 Acciones para alcanzar el Nivel 1 - Realizado

| Acción | Proceso afectado | Responsable | Plazo |
|:---|:---|:---|:---|
| Aprobar los 20 términos del glosario en OpenMetadata (Draft → Approved) | MetDat | Data Steward | Corto plazo |
| Ingestar la BD Grupo10 en OpenMetadata y registrar los 7 activos del catálogo | MetDat | DBA | Corto plazo |
| Automatizar el proceso de matching MDM con eventos Kafka desde CRM y SAP-ISU | MDM | Equipo de Ingesta | Medio plazo |
| Configurar los tests de calidad M-COM-02 y M-ACC-01 en OpenMetadata para ejecución automática | CtrlDQ | Data Steward | Corto plazo |
| Resolver NC-001: añadir validación obligatoria de DNI y email en el formulario de alta del CRM | CtrlDQ | CRM / DPO | Medio plazo |
| Resolver NC-002: activar control TV-02 en el pipeline ETL para filtrar lecturas anómalas en ingesta | CtrlDQ | Equipo ETL | Medio plazo |

### 3.3 Acciones para alcanzar el Nivel 2 - Gestionado

El nivel 2 exige que los procesos no solo se realicen, sino que se gestionen: los objetivos estén planificados, el rendimiento se monitorice y los productos de trabajo estén controlados (AP.2.1 y AP.2.2).

| Acción | Atributo ISO 33000 | Responsable |
|:---|:---|:---|
| Definir objetivos formales de calidad del dato alineados con la estrategia de EnergiTech | AP.2.1 Gestión del Rendimiento | Director del Dato |
| Establecer un ciclo mensual formal de revisión del cuadro de mandos con acta y acuerdos | AP.2.1 | Data Steward + Dir. Operaciones |
| Documentar y versionar todos los artefactos en el repositorio GitHub con criterios de aprobación | AP.2.2 Gestión de Productos de Trabajo | Equipo de Gobierno del Dato |
| Asignar formalmente roles y responsabilidades (Data Owner, Data Steward, DBA) con mandato escrito | AP.2.1 | Dirección |

### 3.4 Reflexión final

La práctica transversal ha servido como iniciativa coyuntural que ha generado los componentes estructurales base del gobierno del dato en EnergiTech: un modelo de proceso documentado, un repositorio de metadatos, un MDM inicial y un sistema de medición de calidad. Estos componentes son la base imprescindible para cualquier nivel de madurez superior.

El salto del nivel actual al nivel 2 no requiere grandes inversiones tecnológicas - las herramientas ya están desplegadas (OpenMetadata, MySQL Spartan, GitHub). Requiere principalmente disciplina organizativa: ejecutar los procedimientos de forma sistemática, asignar responsabilidades formales y cerrar las dos no conformidades identificadas en el P5.
