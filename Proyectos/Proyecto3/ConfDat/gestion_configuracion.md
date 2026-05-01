# ConfDat - Gestion de la Configuracion

**Proyecto:** Proyecto 3 - Gestion de Datos Maestros y Arquitectura de Datos
**Marco de referencia:** UNE 0078 - MDM + ArqDat

---

## Tabla de versiones de artefactos

| ID Artefacto | Nombre | Tipo | Version | Fecha | Estado | Notas |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| ET-MDM-001 | modelo_maestro.md | Documento | 1.0 | 2026-05-01 | En revision | Golden record, matching RM-01/02/03, matriz de autoridad |
| ET-REF-001 | datos_referencia.md | Documento | 1.0 | 2026-05-01 | En revision | Dominios controlados REF-01 a REF-07 |
| ET-ARQ-001 | arquitectura.md | Documento | 1.0 | 2026-05-01 | En revision | Modelos conceptual, logico, fisico y diagrama Mermaid |
| ET-ARQ-001-VP | Modelo conceptual ER (SVG) | Diagrama | 1.0 | 2026-05-01 | En revision | Exportado desde Visual Paradigm Online |
| ET-ARQ-DDL | grupo10_ddl.sql | Script SQL | 1.1 | 2026-05-01 | En revision | Ejecutado en Spartan 172.20.48.70:3306 / Grupo10. FK omitidas por permisos |

---

## Criterios de versionado

- **Mayor (X.0):** cambio estructural - nuevas entidades, rediseno del modelo.
- **Menor (1.X):** anadir atributos o modificar contenido sin cambiar la estructura.
- **Patch (1.0.X):** correccion de errores o aclaraciones menores.

## Estados posibles

| Estado | Descripcion |
| :--- | :--- |
| Pendiente | No creado todavia |
| En desarrollo | Trabajo en curso; no apto para revision externa |
| En revision | Enviado para revision; no modificar hasta resolucion |
| Aprobado | Version final validada |
| Obsoleto | Sustituido por version posterior |
