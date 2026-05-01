# Proyecto 2 - Gestión de Metadatos y Ciclo de Vida del Dato

**Empresa:** EnergiTech | **Asignatura:** Gobierno y Gestión del Dato - MUBDCN, UCLM
**Marco de referencia:** UNE 0087 | **Sesión:** 10

## Contexto

El Proyecto 2 parte de los datasets y sistemas identificados en el Proyecto 1 (ET-PN-001). El objetivo es construir el repositorio de metadatos de EnergiTech siguiendo la arquitectura de tres capas de UNE 0087 - glosario semántico, catálogo de activos y diccionario técnico - y documentar el ciclo de vida del dato desde la ingesta hasta la explotación.

La fuente de verdad del glosario y el catálogo es la instancia de **OpenMetadata** del grupo (Grupo10), accesible en [http://172.20.48.127:8585/glossary/"Grupo10.Glosario"](http://172.20.48.127:8585/glossary/%22Grupo10.Glosario%22). El CSV exportado está disponible en `MetDat/datos/`.

## Entregables

| Artefacto | Archivo | Descripción |
|:---|:---|:---|
| Glosario de negocio | [MetDat/glosario.md](MetDat/glosario.md) | 20 términos G10-001 a G10-020 exportados de OpenMetadata |
| Catálogo de datos | [MetDat/catalogo.md](MetDat/catalogo.md) | 7 activos CT-101 a CT-701 con sus datasets del Proyecto 1 |
| Diccionario de datos | [MetDat/diccionario.md](MetDat/diccionario.md) | Especificación técnica por campo (DT-xxx) |
| Matriz de trazabilidad | [MetDat/trazabilidad.md](MetDat/trazabilidad.md) | Cruce glosario ↔ catálogo ↔ diccionario ↔ BPMN |
| CSV OpenMetadata | [MetDat/datos/EnergiTech_Glosario_OpenMetadata_v2.csv](MetDat/datos/EnergiTech_Glosario_OpenMetadata_v2.csv) | Exportación directa de OpenMetadata - fuente de verdad |
| Pipeline de datos | [CicloVida/ciclo_vida.md](CicloVida/ciclo_vida.md) | Ingesta → Transformación → Almacenamiento → Explotación |
| Políticas de gobierno | [CicloVida/politicas.md](CicloVida/politicas.md) | POL-CV-01 a POL-CV-06 por etapa del ciclo de vida |
| Gestión de configuración | [ConfDat/gestion_configuracion.md](ConfDat/gestion_configuracion.md) | Tabla de versiones de artefactos |

## Estado

| Entregable | Estado | Notas |
|:---|:---|:---|
| Glosario de negocio |  En revisión | Cargado en OpenMetadata con estado Draft - pendiente aprobar |
| Catálogo de datos |  En revisión | CT-101 a CT-701 pendientes de cargar en OpenMetadata |
| Diccionario de datos |  En revisión | DT-301 a DT-701 pendientes de validación técnica |
| Matriz de trazabilidad |  En revisión | |
| Pipeline y políticas |  En revisión | |

## Pendientes en OpenMetadata

1. Aprobar los 20 términos del glosario - cambiar estado de `Draft` a `Approved`.
2. Registrar los 7 activos del catálogo (CT-101 a CT-701) como *Database / Table* y vincularlos a sus términos del glosario.