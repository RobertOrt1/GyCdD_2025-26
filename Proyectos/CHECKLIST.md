# Checklist de Entregables - Practica Transversal GyCdD 2025-26

**Equipo:** Grupo 10 - EnergiTech | **Fecha:** 2026-05-19
**Proceso:** ET-PN-001 - Prevision de la Demanda Energetica

Este documento cruza los requisitos del enunciado con los artefactos del repositorio y el estado de cada entregable.

---

## Proyecto 1 - Modelado de Procesos y Requisitos (UNE 0078 - ProcDat)

| # | Requisito del enunciado | Artefacto en repo | Herramienta | Estado |
| :--- | :--- | :--- | :--- | :--- |
| 1.1 | Modelar el proceso de negocio con BPMN 2.0 | `Proyecto1/ProcDat/proceso_negocio.md` | Visual Paradigm | Aprobado |
| 1.2 | Exportar diagrama BPMN como SVG | `Proyecto1/ProcDat/figuras/bpmn_prevision_demanda_v1.0.svg` | Visual Paradigm | Aprobado |
| 1.3 | Catalogo de requisitos (RN, RD, RC, RS) | `Proyecto1/ReqDat/catalogo_requisitos.md` | Markdown | Aprobado |
| 1.4 | Gestion de la configuracion | `Proyecto1/ConfDat/gestion_configuracion.md` | Markdown | Aprobado |

**Pendiente permanente:** ET-MOD-PRED-001 (modelo IA) - en desarrollo, hiperparametros sin documentar.

---

## Proyecto 2 - Gestion de Metadatos y Ciclo de Vida (UNE 0087 - MetDat)

| # | Requisito del enunciado | Artefacto en repo | Herramienta | Estado |
| :--- | :--- | :--- | :--- | :--- |
| 2.1 | Glosario de negocio (minimo 20 terminos) | `Proyecto2/MetDat/glosario.md` (G10-001 a G10-020) | OpenMetadata + CSV | Aprobado |
| 2.2 | Catalogo de activos de dato | `Proyecto2/MetDat/catalogo.md` (CT-101 a CT-701) | OpenMetadata | Aprobado |
| 2.3 | Diccionario de datos | `Proyecto2/MetDat/diccionario.md` | Markdown | Aprobado |
| 2.4 | Matriz de trazabilidad glosario-catalogo-BPMN | `Proyecto2/MetDat/trazabilidad.md` | Markdown | Aprobado |
| 2.5 | Ciclo de vida del dato con controles ETL | `Proyecto2/CicloVida/ciclo_vida.md` (TV-01 a TV-05) | Markdown + Mermaid | Aprobado |
| 2.6 | Politicas de ciclo de vida | `Proyecto2/CicloVida/politicas.md` (POL-CV-01 a POL-CV-06) | Markdown | Aprobado |
| 2.7 | Gestion de la configuracion | `Proyecto2/ConfDat/gestion_configuracion.md` | Markdown | Aprobado |

**Pendiente en plataforma:** aprobar los 20 terminos del glosario en OpenMetadata (estado Draft -> Approved en la instancia compartida). No bloquea el entregable documental.

---

## Proyecto 3 - Datos Maestros y Arquitectura de Datos (UNE 0078 - MDM + ArqDat)

| # | Requisito del enunciado | Artefacto en repo | Herramienta | Estado |
| :--- | :--- | :--- | :--- | :--- |
| 3.1 | Modelo maestro (golden record, reglas matching) | `Proyecto3/MDM/modelo_maestro.md` (RM-01/02/03) | Visual Paradigm + Markdown | Aprobado |
| 3.2 | Datos de referencia (dominios controlados) | `Proyecto3/MDM/datos_referencia.md` (REF-01 a REF-07) | Markdown | Aprobado |
| 3.3 | Arquitectura conceptual, logica y fisica | `Proyecto3/ArqDat/arquitectura.md` | Mermaid classDiagram | Aprobado |
| 3.4 | Diagrama ER exportado como SVG | `Proyecto3/MDM/figuras/modelo_conceptual_v1.0.svg` | Visual Paradigm | Aprobado |
| 3.5 | DDL ejecutado en base de datos real | `Proyecto3/ArqDat/scripts/grupo10_ddl.sql` (12 tablas) | MySQL 8 - Spartan | Aprobado |
| 3.6 | Evidencia de tablas en BD | `Proyecto3/MDM/figuras/ModeladoFisico.jpeg` | DBeaver | Aprobado |
| 3.7 | Gestion de la configuracion | `Proyecto3/ConfDat/gestion_configuracion.md` | Markdown | Aprobado |

**Nota:** FK constraints omitidas en DDL por permiso REFERENCES denegado en Spartan. Integridad referencial documentada en comentarios de columna y en el modelo logico.

---

## Proyecto 4 - Medicion de la Calidad del Dato (UNE 0081 - CalDat)

| # | Requisito del enunciado | Artefacto en repo | Herramienta | Estado |
| :--- | :--- | :--- | :--- | :--- |
| 4.1 | Modelo de calidad con caracteristicas y umbrales | `Proyecto4/ModeloCalidad/modelo_calidad.md` | UNE 0081 + Mermaid | Aprobado |
| 4.2 | Metodos de medicion con SQL ejecutable | `Proyecto4/Medicion/medidas.md` (M-COM-01/02, M-CON-01/02, M-ACC-01/02) | MySQL / DBeaver | Aprobado |
| 4.3 | Resultados de medicion con interpretacion | `Proyecto4/Medicion/medidas.md` - §4 Resultados | DBeaver sobre Spartan | Aprobado |
| 4.4 | Gestion de la configuracion | `Proyecto4/ConfDat/gestion_configuracion.md` | Markdown | Aprobado |

**Resultados clave:** M-COM-02 al 70% (NC-001) y M-ACC-01 al 92,31% (NC-002). Detalle en Proyecto 5.

---

## Proyecto 5 - Control y Monitorizacion de la Calidad (UNE 0079 - PlanDQ/CtrlDQ)

| # | Requisito del enunciado | Artefacto en repo | Herramienta | Estado |
| :--- | :--- | :--- | :--- | :--- |
| 5.1 | Requisitos de calidad priorizados (CtrlDQ.T1) | `Proyecto5/Procedimientos/procedimientos_medicion.md` - §1 | Markdown | Aprobado |
| 5.2 | Flujo general del ciclo de medicion | `Proyecto5/Procedimientos/procedimientos_medicion.md` - §2 (Mermaid flowchart) | Mermaid | Aprobado |
| 5.3 | Procedimientos de medicion por medida (CtrlDQ.T2) | `Proyecto5/Procedimientos/procedimientos_medicion.md` - §3 (PROC-COM-01/02, PROC-CON-01/02, PROC-ACC-01/02) | Markdown + SQL | Aprobado |
| 5.4 | Cuadro de mandos | `Proyecto5/Monitorizacion/cuadro_mandos.md` | Markdown + OpenMetadata | Aprobado |
| 5.5 | Soporte en herramienta de calidad | `Proyecto5/Monitorizacion/cuadro_mandos.md` - §3 (capturas OpenMetadata) | OpenMetadata 1.6.7 | Aprobado |
| 5.6 | Registro de no conformidades (CtrlDQ.T4) | `Proyecto5/Monitorizacion/no_conformidades.md` (NC-001, NC-002) | Markdown | Aprobado |
| 5.7 | Gestion de la configuracion | `Proyecto5/ConfDat/gestion_configuracion.md` | Markdown | Aprobado |

**Pendiente en plataforma:** configurar tests M-COM-02 y M-ACC-01 en OpenMetadata para ejecucion automatica mensual (requiere ingestar Grupo10, bloqueado por permisos en instancia compartida).

---

## Proyecto 6 - Evaluacion de Madurez (UNE 0080 - MAMD)

| # | Requisito del enunciado | Artefacto en repo | Herramienta | Estado |
| :--- | :--- | :--- | :--- | :--- |
| 6.1 | Autoevaluacion de madurez con modelo MAMD | `Proyecto6/Autoevaluacion/autoevaluacion.md` (ProcDat/MetDat/MDM/PlanDQ/CtrlDQ) | UNE 0080 + Mermaid | Aprobado |
| 6.2 | Plan de mejora hacia NM1 y NM2 | `Proyecto6/PlanMejora/plan_mejora.md` | Markdown | Aprobado |
| 6.3 | Gestion de la configuracion | `Proyecto6/ConfDat/gestion_configuracion.md` | Markdown | Aprobado |

**Resultado de madurez:** en transicion hacia Nivel 1 (ProcDat=F, PlanDQ=F; MetDat/MDM/CtrlDQ=L por dependencias de plataforma).

---

## Resumen de herramientas utilizadas

| Herramienta | Uso en la practica |
| :--- | :--- |
| Visual Paradigm Online | Diagrama BPMN (P1), diagrama ER conceptual (P3) |
| OpenMetadata 1.6.7 | Glosario de negocio, catalogo de activos (P2), soporte tests de calidad (P5) |
| MySQL 8 / Spartan | DDL de 12 tablas en BD Grupo10 (P3), ejecucion de queries de medicion (P4) |
| DBeaver | Conexion a Spartan, ejecucion de medidas, capturas de evidencia (P3, P4) |
| Mermaid | Diagramas en Markdown: flowchart BPMN simplificado (P1), classDiagram logico (P3), flujo medicion (P5), escalera madurez (P6) |
| Git / GitHub | Control de versiones en rama develop |
| VS Code | Edicion de Markdown con preview Mermaid (Ctrl+Shift+V) |

---

## Items pendientes que no son entregables documentales

| Item | Razon pendiente | Responsable |
| :--- | :--- | :--- |
| Aprobar 20 terminos glosario en OpenMetadata (Draft -> Approved) | Requiere accion manual en la plataforma por el Data Steward | Cualquier miembro del equipo |
| Ingestar BD Grupo10 en OpenMetadata | Permiso denegado en instancia compartida; escalar al profesor si es necesario | Coordinador |
| Configurar tests automaticos M-COM-02 y M-ACC-01 en OpenMetadata | Depende de la ingesta anterior | Data Steward (tras ingesta) |
| Ver sesiones 11, 12 y 13 de clase | Validar alineacion del trabajo con lo explicado en clase | Todos |
