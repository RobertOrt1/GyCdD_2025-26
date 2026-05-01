# Proyecto 1 - Procesamiento del Dato y Gestion de Requisitos

**Empresa:** EnergiTech | **Asignatura:** Gobierno y Gestion del Dato - MUBDCN, UCLM
**Marco de referencia:** UNE 0078 - ProcDat | **Sesion:** 9

## Contexto

EnergiTech quiere implementar un nuevo sistema de analisis predictivo basado en tecnicas de inteligencia artificial para la gestion de la demanda energetica, especialmente para garantizar la satisfaccion de las necesidades de los clientes mas criticos.

Para ello es necesario, primero, describir como funciona el proceso de negocio que calcula esa prevision: que datos se usan, en que orden, que controles se aplican y que produce al final. No interesa el algoritmo en si, sino todo el proceso que ejecutaria un trabajador del negocio (es como si ese trabajador "usara una funcion de Excel para el calculo de la prevision de la demanda"). Segundo, hay que identificar y documentar los requisitos que debe cumplir ese sistema: que espera la empresa del analisis predictivo, que datos necesita, desde que fuentes, en que formato, con que nivel de calidad y con que garantias de seguridad.

EnergiTech arrastra ademas problemas previos que condicionan el proyecto: clientes duplicados en CRM, ERP y SCADA, errores recurrentes en los informes de consumo y prevision de demanda, y falta de trazabilidad sobre quien accede a los datos sensibles.

## Tareas

**Tarea 1 - Descripcion del proceso de negocio (ProcDat)**
Modelar el proceso de negocio para el calculo de la prevision de la demanda energetica, describiendo las etapas del procesamiento, las instrucciones de trabajo y los datos usados en cada actividad. Herramienta: BPMN con Visual Paradigm (Nota 1).

**Tarea 2 - Identificacion de requisitos de datos (ReqDat)**
Definir requisitos de negocio (que espera la empresa del sistema predictivo), requisitos de datos (fuentes, formatos, aspectos de seguridad) y requisitos de calidad del dato. Para cada requisito: fuente, prioridad y trazabilidad con el proceso. Herramienta: plantilla estructurada (Nota 2).

> Nota 3: Se aplica gestion de configuracion para mantener la integridad de los artefactos generados y comunicar versiones al equipo.

## Entregables

| Artefacto | Archivo | Descripcion |
| :--- | :--- | :--- |
| Proceso de negocio (ProcDat) | [ProcDat/proceso_negocio.md](ProcDat/proceso_negocio.md) | Descripcion del proceso + diagrama BPMN |
| Catalogo de requisitos (ReqDat) | [ReqDat/catalogo_requisitos.md](ReqDat/catalogo_requisitos.md) | Requisitos de negocio, datos, calidad y seguridad |
| Gestion de configuracion (ConfDat) | [ConfDat/gestion_configuracion.md](ConfDat/gestion_configuracion.md) | Tabla de versiones de artefactos |

## Estado del proyecto

| Entregable | Estado |
| :--- | :--- |
| Diagrama BPMN (Visual Paradigm) | En revision |
| Descripcion del proceso de negocio | En revision |
| Catalogo de requisitos | En revision |
| Gestion de configuracion | En revision |
