# GyCdD 2025-26 - Gobierno y Gestion del Dato

**Asignatura:** Gobierno y Gestion del Dato - MUBDCN, UCLM
**Marco de referencia:** UNE 0078 / UNE 0087

---

## Introduccion a la iniciativa transversal

EnergiTech, multinacional dedicada a la distribucion de energia renovable, atraviesa graves problemas operativos cuya causa raiz esta en los datos que usa y explota en sus procesos de negocio. Se sabe que los datos de clientes presentan graves problemas de calidad y de acceso: estan duplicados en varios sistemas, los informes de consumo y de prediccion de la demanda presentan errores de calculo, y no existe trazabilidad clara de quien accede a los datos sensibles ni con que proposito.

La direccion ha lanzado una iniciativa de gobierno de datos para mejorar la explotacion del negocio. El equipo de gobierno del dato ha disenado una estrategia que incluye distintos programas y proyectos especificos que, como responsables de la gestion de datos de EnergiTech, se nos ha pedido ejecutar.

El objetivo de esta practica transversal es abordar, siguiendo los procesos de gestion de datos especificados en la especificacion **UNE 0078**, los proyectos concatenados que se detallan a continuacion. Cada uno se aborda en la sesion indicada y los temas se secuencian de acuerdo a los temas de teoria.

---

## Proyectos

| Proyecto | Sesion | Descripcion | Marco | Estado |
| :--- | :--- | :--- | :--- | :--- |
| [Proyecto 1](Proyectos/Proyecto1/README.md) | 09 | Procesamiento del Dato y Gestion de Requisitos | UNE 0078 - ProcDat | En revision |
| [Proyecto 2](Proyectos/Proyecto2/README.md) | 10 | Gestion de Metadatos y Ciclo de Vida del Dato | UNE 0087 - MetDat | En revision |
| [Proyecto 3](Proyectos/Proyecto3/README.md) | 11 | Gestion de Datos Maestros y Arquitectura de Datos | UNE 0078 - MDM + ArqDat | En revision |

---

## Proyecto 1 (Sesion 09) - Procesamiento del Dato y Gestion de Requisitos

EnergiTech quiere implementar un nuevo sistema de analisis predictivo basado en tecnicas de inteligencia artificial para la gestion de la demanda energetica, especialmente para garantizar la satisfaccion de las necesidades de los clientes mas criticos. Se requiere abordar las siguientes tareas:

**Tarea 1 - Descripcion del proceso de negocio:** Describir el modelo de proceso de negocio que modela como se calcula la prevision de la demanda energetica, especificando las instrucciones de procesamiento de datos. Describir, de forma exploratoria, las etapas del procesamiento y los datos que deben usarse en cada actividad. Lo importante no es el algoritmo de prevision en si, sino todo el proceso que ejecutaria un trabajador del negocio (como si usara una funcion de Excel para el calculo).

**Tarea 2 - Identificacion de requisitos de datos:** Definir requisitos para el proceso de negocio (que espera la empresa del analisis predictivo), requisitos de datos (que datos emplear, desde que fuentes, en que formato, aspectos de seguridad) y requisitos especificos de calidad del dato. Identificar fuentes de requisitos y su prioridad.

- Nota 1: Uso de BPMN con Visual Paradigm (licencia academica disponible).
- Nota 2: Plantilla estructurada para los requisitos (Excel o Markdown).
- Nota 3: Aplicar gestion de configuracion para mantener la integridad de los artefactos.

Ver detalles: [Proyectos/Proyecto1/README.md](Proyectos/Proyecto1/README.md)

---

## Proyecto 2 (Sesion 10) - Gestion de Metadatos y Ciclo de Vida del Dato

[PENDIENTE - anadir enunciado cuando este disponible]

Ver detalles: [Proyectos/Proyecto2/README.md](Proyectos/Proyecto2/README.md)

---

## Proyecto 3 (Sesion 11) - Gestion de Datos Maestros y Arquitectura de Datos

Ademas de los problemas anteriores, se ha detectado la existencia de silos de datos: copias de los mismos datos en distintos lugares sin control de redundancia, lo que crea ambiguedad y desconfianza. Por ejemplo, un mismo cliente, "Juan Perez", aparece registrado con tres IDs distintos porque contrato luz, gas y mantenimiento de forma separada, en momentos distintos y usando tres IDCliente diferentes. Se plantea la necesidad de crear un repositorio de datos maestros ("el dato unico") para homogeneizar la informacion y reducir las brechas en los dominios de datos.

**Tarea 1 - Creacion de Datos Maestros:** Proponer un modelo de registro de datos maestros para la entidad Cliente. Que atributos maestros identifican que se trata de la misma persona (matching), que sistema debe ser la fuente de verdad para cada atributo, y cuales son los datos de referencia.

**Tarea 2 - Arquitectura de datos:** Proponer una arquitectura de datos para dar soporte al analisis. Debe incluir soporte al intercambio de datos entre los repositorios que serviran de base para la gestion de los datos maestros.

- Nota 6: Para el modelado de entidades maestras se pueden usar herramientas como Visual Paradigm.
- Nota 7: No interesa el metodo analitico en si, pero la arquitectura de datos si debe modelarse orientada a dar soporte al ciclo de vida analitico.

Ver detalles: [Proyectos/Proyecto3/README.md](Proyectos/Proyecto3/README.md)
