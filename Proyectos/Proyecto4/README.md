# Proyecto 4 - Medición de la Calidad del Dato

**Empresa:** EnergiTech | **Asignatura:** Gobierno y Gestión del Dato - MUBDCN, UCLM
**Marco de referencia:** UNE 0081 (basada en ISO/IEC 25012, 25024 y 25040) | **Sesión:** 12

## Contexto

Los proyectos anteriores identificaron los problemas de datos de EnergiTech y sentaron las bases para resolverlos: el Proyecto 1 definio los requisitos del sistema predictivo, el Proyecto 2 establecio los metadatos y el ciclo de vida del dato, y el Proyecto 3 creo el repositorio de datos maestros y la arquitectura de datos. Sin embargo, ningúno de ellos mide de forma objetiva si la calidad del dato es suficiente para que el proceso de previsión de demanda (ET-PN-001) pueda ejecutarse con garantias.

Este proyecto aborda esa laguna aplicando el marco de evaluación de UNE 0081: se define un modelo de calidad con tres características selecciónadas y se especifican los métodos de medición con sus formulas, umbrales y consultas SQL ejecutables sobre la base de datos Grupo10 en Spartan.

## Tareas

**Tarea 1 - Modelo de calidad del dato**
Selecciónar y justificar las características de calidad relevantes para el proceso ET-PN-001 segun UNE 0081. Definir los umbrales de aceptacion alineados con el apetito de riesgo de EnergiTech y los requisitos del Proyecto 1.

**Tarea 2 - Métodos de medición**
Especificar las propiedades medibles (Com-I-1/2, Con-I-1/2, Acc-I-2/3) con sus formulas de cálculo, datasets afectados y consultas SQL implementables en MySQL 8 sobre la base de datos Grupo10.

## Entregables

| Artefacto | Archivo | Descripción |
| :--- | :--- | :--- |
| Modelo de calidad | [ModeloCalidad/modelo_calidad.md](ModeloCalidad/modelo_calidad.md) | Características selecciónadas, apetito de riesgo, escala UNE 0081, diagrama Mermaid y tabla resumen |
| Métodos de medición | [Medición/medidas.md](Medición/medidas.md) | Seis medidas M-COM-01/02, M-CON-01/02, M-ACC-01/02 con formulas y SQL |
| Gestión de configuración | [ConfDat/gestión_configuración.md](ConfDat/gestión_configuración.md) | Tabla de versiónes de artefactos |

## Estado del proyecto

| Entregable | Estado |
| :--- | :--- |
| Modelo de calidad (modelo_calidad.md) | En revisión |
| Métodos de medición (medidas.md) | En revisión |
| Gestión de configuración | En revisión |