# Proyecto 5 - Control y Monitorizacion de la Calidad del Dato

**Empresa:** EnergiTech | **Asignatura:** Gobierno y Gestion del Dato - MUBDCN, UCLM
**Marco de referencia:** UNE 0079 - PlanDQ / CtrlDQ | **Sesion:** 13

## Contexto

El Proyecto 4 midio el estado actual de la calidad del dato en EnergiTech y revelo dos no conformidades: la completitud de registros del golden record (M-COM-02 al 70%, por debajo del umbral del 90%) y la exactitud del rango de consumo (M-ACC-01 al 92,31%, por debajo del 98%). Estos resultados impiden ejecutar el proceso ET-PN-001 en condiciones seguras.

Este proyecto da el siguiente paso: convertir esas medidas puntuales en un sistema de control y monitorizacion continua. Se definen procedimientos formales para cada medida, un cuadro de mandos consolidado para la Direccion de Operaciones y el registro de no conformidades con sus acciones correctoras, siguiendo las tareas CtrlDQ.T1 a CtrlDQ.T4 de UNE 0079.

## Tareas

**Tarea 1 - Requisitos de calidad priorizados (CtrlDQ.T1)**
Ordenar por criticidad los seis requisitos de calidad derivados del Proyecto 1 y los resultados del Proyecto 4.

**Tarea 2 - Procedimientos de medicion (CtrlDQ.T2)**
Definir un procedimiento formal por cada medida: responsable, frecuencia, herramienta, query de diagnostico y plan de accion ante no conformidad.

**Tarea 3 - Cuadro de mandos (CtrlDQ.T3)**
Consolidar los resultados del ultimo ciclo de medicion en una vista unica y configurar OpenMetadata como herramienta de soporte para la monitorizacion continua.

**Tarea 4 - No conformidades y lecciones aprendidas (CtrlDQ.T4)**
Registrar las no conformidades NC-001 y NC-002 con causa raiz, accion correctora y leccion aprendida.

## Entregables

| Artefacto | Archivo | Descripcion |
| :--- | :--- | :--- |
| Procedimientos de medicion | [Procedimientos/procedimientos_medicion.md](Procedimientos/procedimientos_medicion.md) | Requisitos priorizados (CtrlDQ.T1), flujo Mermaid y seis procedimientos PROC-xxx (CtrlDQ.T2) |
| Cuadro de mandos | [Monitorizacion/cuadro_mandos.md](Monitorizacion/cuadro_mandos.md) | Tabla de estado mayo 2026, diagrama Mermaid por colores y configuracion OpenMetadata (CtrlDQ.T3) |
| No conformidades | [Monitorizacion/no_conformidades.md](Monitorizacion/no_conformidades.md) | NC-001 y NC-002 con causa raiz, acciones correctoras y leccion aprendida (CtrlDQ.T4) |
| Gestion de configuracion | [ConfDat/gestion_configuracion.md](ConfDat/gestion_configuracion.md) | Tabla de versiones de artefactos |

## Estado del proyecto

| Entregable | Estado |
| :--- | :--- |
| Procedimientos de medicion | En revision |
| Cuadro de mandos | En revision |
| No conformidades | En revision |
| Gestion de configuracion | En revision |
