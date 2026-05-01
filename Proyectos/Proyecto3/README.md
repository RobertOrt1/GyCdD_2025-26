# Proyecto 3 - Gestion de Datos Maestros y Arquitectura de Datos

**Empresa:** EnergiTech | **Asignatura:** Gobierno y Gestion del Dato - MUBDCN, UCLM
**Marco de referencia:** UNE 0078 - MDM (4.11) + ArqDat (4.9) | **Sesion:** 11

## Contexto

Ademas de los problemas de calidad y metadatos abordados en P1 y P2, EnergiTech sufre un problema estructural de silos de datos: los mismos datos existen en distintos lugares sin control de redundancia, lo que genera ambiguedad y desconfianza en el dato. El caso mas claro es el de los clientes: un mismo ciudadano, como "Juan Perez", puede aparecer con tres IDs distintos porque contrato luz, gas y mantenimiento de forma separada y en momentos diferentes, cada vez en un sistema distinto.

Para resolver esto se plantea la creacion de un repositorio de datos maestros (MDM), tambien llamado "dato unico" o "dato unificado", que homogeneice la informacion y elimine las brechas en los dominios de datos. Complementariamente, se necesita una arquitectura de datos que soporte el intercambio entre los sistemas fuente, el MDM y los repositorios analiticos.

> Nota 6: Para el modelado de entidades de datos maestros se pueden usar herramientas como Visual Paradigm.
> Nota 7: No interesa el metodo analitico en si, pero la arquitectura de datos si debe modelarse orientada a dar soporte al ciclo de vida analitico.

## Tareas

**Tarea 1 - Creacion de Datos Maestros (MDM)**
Proponer un modelo de registro maestro para la entidad Cliente: que atributos permiten identificar que se trata de la misma persona (matching), que sistema es la fuente de verdad para cada atributo, y cuales son los datos de referencia (dominios controlados).

**Tarea 2 - Arquitectura de datos (ArqDat)**
Proponer una arquitectura de datos para dar soporte al analisis. Debe incluir el modelo conceptual de entidades, el modelo logico relacional, el modelo fisico (DDL MySQL) y el soporte al intercambio de datos entre los repositorios que sirven de base para la gestion de datos maestros.

## Entregables

| Artefacto | Archivo | Descripcion |
| :--- | :--- | :--- |
| Registro maestro MDM | [MDM/modelo_maestro.md](MDM/modelo_maestro.md) | Golden record Cliente, matching RM-01/02/03, matriz de autoridad |
| Datos de referencia | [MDM/datos_referencia.md](MDM/datos_referencia.md) | Dominios controlados REF-01 a REF-07 |
| Arquitectura de datos | [ArqDat/arquitectura.md](ArqDat/arquitectura.md) | Modelos conceptual, logico y fisico + diagrama Mermaid |
| DDL MySQL | [ArqDat/scripts/grupo10_ddl.sql](ArqDat/scripts/grupo10_ddl.sql) | Script para Spartan 172.20.48.70:3306 / Grupo10 |
| Gestion de configuracion | [ConfDat/gestion_configuracion.md](ConfDat/gestion_configuracion.md) | Tabla de versiones de artefactos |

## Estado del proyecto

| Entregable | Estado |
| :--- | :--- |
| Modelo maestro MDM | En revision |
| Datos de referencia | En revision |
| Arquitectura (conceptual + logico + Mermaid) | En revision |
| Modelo conceptual VP (SVG) | Pendiente - exportar desde Visual Paradigm |
| DDL MySQL ejecutado en Spartan | Pendiente - ejecutar grupo10_ddl.sql |
