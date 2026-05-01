# CicloVida - Políticas de Gobierno del Dato

**Identificador:** ET-POL-001
**Versión:** 1.0 | **Fecha:** 2026-05-01
**Marco de referencia:** UNE 0087

> Las políticas definen las reglas de operación obligatorias en cada etapa del ciclo de vida.
> Cada política incluye la prohibición estricta asociada para dejar claro qué está explícitamente vetado.

---

## Políticas por etapa

| Código | Etapa | Política de operación | Prohibición estricta |
|:---|:---|:---|:---|
| **POL-CV-01** | Ingesta | La tokenización SHA-256 de `id_cliente` es obligatoria antes de que el dato salga del sistema CRM hacia cualquier repositorio analítico. | Prohibido que el ID real (`id_cliente`) exista en el Data Lake bajo cualquier formato. |
| **POL-CV-02** | Ingesta | Solo pueden ingestar datos las fuentes registradas y autorizadas en el catálogo (CT-101 a CT-501). | Prohibida cualquier ingesta ad-hoc o desde fuentes no catalogadas ("shadow data"). |
| **POL-CV-03** | Transformación | Todo dato rechazado durante la fase ETL debe registrarse con motivo de rechazo, timestamp y responsable en el log de auditoría. | Prohibido descartar o ignorar datos sin dejar registro. |
| **POL-CV-04** | Almacenamiento | Los entornos con datos identificables (capa Bronze) y los entornos analíticos (Silver/Gold) deben estar físicamente separados, con controles de acceso independientes. | Prohibida la re-identificación de personas en las capas Silver y Gold. |
| **POL-CV-05** | Almacenamiento | La purga de datos se ejecuta automáticamente al vencer el plazo de retención: 7 años (Bronze), 5 años (Silver), 3 años (Gold). | Prohibido conservar datos más allá del plazo sin base legal documentada y aprobada por el DPO. |
| **POL-CV-06** | Explotación | El acceso a cada capa del Data Lake/Warehouse está controlado por RBAC según el rol del usuario. Los perfiles de BI y Dirección solo acceden a la capa Gold. | Prohibido el acceso de perfiles de BI, Analítica de negocio o Dirección a la capa Bronze (datos crudos). |

---

## Roles RBAC 

| Rol | Capa accesible | Sistemas |
|:---|:---|:---|
| DBA | Bronze, Silver, Gold | Todos |
| Analista de Demanda | Silver, Gold | Data Lake, MLflow |
| Data Steward | Silver, Gold | Data Lake, OpenMetadata |
| Operaciones | Gold | Power BI, repositorio documental |
| Dirección | Gold | Power BI, repositorio documental |

---

## Responsables 

| Política | Responsable de definición | Responsable de cumplimiento |
|:---|:---|:---|
| POL-CV-01 | DPO | Equipo de Ingesta / Data Steward |
| POL-CV-02 | Data Steward | Equipo de Ingesta |
| POL-CV-03 | Data Steward | Equipo ETL |
| POL-CV-04 | DPO / DBA | DBA |
| POL-CV-05 | DPO | DBA |
| POL-CV-06 | Data Steward | DBA |
