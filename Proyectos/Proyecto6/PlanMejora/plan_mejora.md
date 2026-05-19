# Plan de Mejora de Madurez

**Identificador:** ET-MAD-PM-001 | **Versión:** 1.0 | **Fecha:** 2026-05-02
**Marco de referencia:** UNE 0080 - MAMD (basado en ISO/IEC 33000)
**Proceso asociado:** ET-PN-001 - Previsión de la Demanda Energética

Ver evaluación de la situación actual en [Autoevaluacion/autoevaluacion.md](../Autoevaluacion/autoevaluacion.md).

---

## 1. Suficiencia del nivel actual

Para una multinacional del sector energético que distribuye suministro a clientes críticos (hospitales, centros de datos, residencias), el nivel actual no es suficiente. EnergiTech necesita garantías de continuidad de suministro que requieren datos fiables, procesos reproducibles y monitorización automatizada. El Nivel 1 sería el mínimo operativo aceptable; el Nivel 2 sería el objetivo realista a corto plazo.

---

## 2. Acciones para alcanzar el Nivel 1 - Realizado

El objetivo es convertir en F los tres procesos actualmente en L. Todas las acciones se apoyan en herramientas ya desplegadas - no se requiere nueva infraestructura.

| Acción | Proceso afectado | Responsable | Plazo |
| :--- | :--- | :--- | :--- |
| Aprobar los 20 términos del glosario en OpenMetadata (Draft -> Approved) | MetDat | Data Steward | Corto plazo |
| Ingestar la BD Grupo10 en OpenMetadata y registrar los 7 activos del catálogo (CT-101 a CT-701) | MetDat | DBA | Corto plazo |
| Automatizar el proceso de matching MDM con eventos desde CRM y SAP-ISU | MDM | Equipo de Ingesta | Medio plazo |
| Configurar los tests M-COM-02 y M-ACC-01 en OpenMetadata para ejecución automática mensual | CtrlDQ | Data Steward | Corto plazo |
| Resolver NC-001: añadir validación obligatoria de DNI y email en el formulario de alta del CRM | CtrlDQ | CRM / DPO | Medio plazo |
| Resolver NC-002: activar control TV-02 en el pipeline ETL para filtrar lecturas anómalas en ingesta | CtrlDQ | Equipo ETL | Medio plazo |

---

## 3. Acciones para alcanzar el Nivel 2 - Gestionado

El Nivel 2 exige que los procesos no solo se realicen, sino que se gestionen: los objetivos estén planificados, el rendimiento se monitorice y los productos de trabajo estén controlados (AP.2.1 y AP.2.2 de ISO 33000).

| Acción | Atributo ISO 33000 | Responsable |
| :--- | :--- | :--- |
| Definir objetivos formales de calidad del dato alineados con la estrategia de EnergiTech | AP.2.1 Gestión del Rendimiento | Director del Dato |
| Establecer un ciclo mensual formal de revisión del cuadro de mandos con acta y acuerdos | AP.2.1 | Data Steward + Dir. Operaciones |
| Documentar y versionar todos los artefactos en el repositorio GitHub con criterios de aprobación | AP.2.2 Gestión de Productos de Trabajo | Equipo de Gobierno del Dato |
| Asignar formalmente roles y responsabilidades (Data Owner, Data Steward, DBA) con mandato escrito | AP.2.1 | Dirección |

---

## 4. Reflexión final

La práctica transversal ha servido como iniciativa coyuntural que ha generado los componentes estructurales base del gobierno del dato en EnergiTech: un modelo de proceso documentado, un repositorio de metadatos, un MDM inicial y un sistema de medición de calidad. Estos componentes son la base imprescindible para cualquier nivel de madurez superior.

El salto del nivel actual al Nivel 2 no requiere grandes inversiones tecnológicas - las herramientas ya están desplegadas (OpenMetadata, MySQL Spartan, GitHub). Requiere principalmente disciplina organizativa: ejecutar los procedimientos de forma sistemática, asignar responsabilidades formales y cerrar las dos no conformidades identificadas en el Proyecto 5.
