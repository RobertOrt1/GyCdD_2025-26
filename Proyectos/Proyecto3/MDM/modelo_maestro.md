# MDM - Modelo de Registro Maestro

**Identificador:** ET-MDM-001 | **Version:** 1.0 | **Fecha:** 2026-05-01
**Marco de referencia:** UNE 0078 - MDM.T1 / MDM.T2
**Proceso asociado:** ET-PN-001 - Prevision de la Demanda Energetica

---

## 1. Contexto y motivacion

Los proyectos anteriores confirmaron que EnergiTech arrastra una fragmentacion de la entidad Cliente entre tres sistemas operacionales (CRM Salesforce, SAP-ISU y ERP de Mantenimiento). Un mismo ciudadano genera identidades divergentes sin mecanismos de conciliacion, lo que invalida la agregacion de consumos y distorsiona el modelo predictivo de demanda.

Este documento especifica el Repositorio de Datos Maestros (MDM) para la entidad Cliente: el registro maestro unico, las reglas de matching, la fuente de verdad por atributo y el estilo arquitectonico elegido.

---

## 2. Diagnostico de fragmentacion

La siguiente muestra, extraida de la auditoria de datos, ilustra como un mismo ciudadano genera tres registros divergentes:

| Sistema origen | Identificador local | Nombre | Direccion | Email |
| :--- | :--- | :--- | :--- | :--- |
| CRM - Electricidad | `LUZ-0123` | Juan Perez Garcia | Av. Constitucion 12, 3B | juan.perez@correo.es |
| SAP-ISU - Gas | `GAS-0321` | Juan Perez | C/Constitucion n12 - 3B | jperez@correo.es |
| ERP - Mantenimiento | `MANT-1230` | J. Perez Garcia | Constitucion, 12 3B | juan.perez@correo.es |

**Impacto identificado:**

- La agregacion erronea de consumos distorsiona el calculo de demanda por segmento (afecta directamente a ET-PN-001).
- La falta de trazabilidad de identidad dificulta el cumplimiento RGPD y el control de accesos a datos sensibles.
- La fragmentacion impide la consolidacion de facturacion y genera desconfianza en los reportes de negocio.

---

## 3. Estilo arquitectonico MDM elegido

Se adopta el estilo **Consolidacion** (Consolidation MDM):

- El MDM crea un registro maestro de solo lectura (golden record) a partir de los sistemas fuente, sin reescribir en los sistemas operacionales.
- Es el estilo menos disruptivo para EnergiTech en esta fase: no requiere cambios en CRM ni en SAP-ISU.
- El golden record se publica hacia el entorno analitico (capa Silver del Data Lake), no hacia los sistemas de origen.
- En fases posteriores podria evolucionarse a un estilo Coexistence si se decide sincronizar la identidad maestra de vuelta a los sistemas.

---

## 4. Jerarquia de entidades maestras

Se priorizan tres entidades para la estabilizacion del modelo analitico, en orden de criticidad:

| Prioridad | Entidad | Justificacion |
| :--- | :--- | :--- |
| 1 - Critica | Cliente | Entidad con mayor fragmentacion; es clave para el modelo predictivo |
| 2 - Alta | Punto de Suministro (CUPS) | Nexo entre el cliente y el consumo fisico medido |
| 3 - Media | Zona Geografica | Dimension necesaria para la integracion meteorologica |

---

## 5. Registro maestro: entidad Cliente

### 5.1 Atributos del golden record

Los tipos de campo son coherentes con el diccionario P2 (DT-101-xx). El dominio de `tipo_cliente` usa los codigos del diccionario ({RES, IND, CRIT}), no los nombres largos del borrador previo.

> **Nota:** El borrador inicial usaba {RESIDENCIAL, PYME, INDUSTRIAL, CRITICO}. Prevalece el dominio definido en DT-101-03: {RES, IND, CRIT}. PYME queda como [PENDIENTE DE VALIDACION] con Direccion Comercial.

| Atributo | Tipo | Fuente de verdad | Descripcion |
| :--- | :--- | :--- | :--- |
| `id_cliente_maestro` | UUID | MDM (generado) | Identificador unico e inmutable del golden record |
| `id_nacional` | VARCHAR(20) | CRM (validado) | DNI o NIE; clave de matching de mayor precision |
| `id_cliente_token` | VARCHAR(64) | MDM | SHA256(id_cliente_maestro + salt). Circula en el pipeline analitico |
| `nombre_normalizado` | VARCHAR(100) | MDM (limpieza) | Nombre canonico tras normalizacion y deduplicacion |
| `tipo_cliente` | VARCHAR(20) | CRM | Dom: {RES, IND, CRIT}. Asignado en alta comercial |
| `sla_reforzado` | BOOLEAN | Direccion de Operaciones | TRUE si tipo_cliente = CRIT |
| `estado` | VARCHAR(20) | CRM | Dom: {ACTIVO, SUSPENDIDO, BAJA} |
| `email_verificado` | VARCHAR(150) | CRM | Email validado; usado en regla RM-02 |
| `fecha_alta_maestra` | DATE | MDM | Fecha de creacion del golden record |
| `mapping_ids_legados` | JSON | MDM | Lista de IDs de los sistemas fuente mapeados a este registro |

### 5.2 Reglas de matching (MDM.T1)

El motor de MDM aplica las reglas en orden de precision decreciente. Una regla positiva detiene la evaluacion.

| Codigo | Nombre | Criterio | Score | Accion |
| :--- | :--- | :--- | :--- | :--- |
| RM-01 | Identidad exacta | Coincidencia exacta de `id_nacional` (DNI/NIE) | 100% | Fusion automatica |
| RM-02 | Contacto verificado | Coincidencia exacta de `email_verificado` normalizado | 95% | Fusion automatica |
| RM-03 | Similitud difusa | Score > 85% sobre combinacion de nombre normalizado + direccion (algoritmo Levenshtein) | 85-99% | Propuesta para revision manual |

Los registros sin match crean un nuevo golden record. Los casos de RM-03 con score < 85% se marcan como `DUPLICADO_POTENCIAL` y se escalan al Data Steward.

### 5.3 Matriz de autoridad por atributo (MDM.T2)

Define que sistema tiene la ultima palabra sobre cada atributo en caso de conflicto entre fuentes.

| Atributo | Sistema de autoridad | Sistema secundario | Criterio de desempate |
| :--- | :--- | :--- | :--- |
| `id_nacional` | CRM Salesforce | - | Unico sistema con validacion de identidad |
| `nombre_normalizado` | MDM (derivado) | CRM | Resultado del proceso de limpieza |
| `tipo_cliente` | CRM Salesforce | Direccion de Operaciones | CRM es fuente de contratos |
| `sla_reforzado` | Direccion de Operaciones | CRM | Decision operativa, no contractual |
| `estado` | CRM Salesforce | SAP-ISU | Estado del contrato principal |
| `email_verificado` | CRM Salesforce | ERP | CRM tiene el proceso de verificacion |
| `cups` (suministros) | SAP-ISU | CRM | SAP-ISU es el sistema de gestion de suministros |

---

## 6. Politicas de gobierno del MDM

| Codigo | Politica | Descripcion |
| :--- | :--- | :--- |
| POL-MDM-01 | Fuente de autoridad | Cada atributo se actualiza exclusivamente desde su sistema de autoridad (ver matriz 5.3) |
| POL-MDM-02 | Inmutabilidad del UUID | El `id_cliente_maestro` no puede modificarse ni reutilizarse una vez generado |
| POL-MDM-03 | Auditoria obligatoria | Toda fusion, actualizacion o baja del golden record se registra con timestamp, usuario y motivo |
| POL-MDM-04 | Seudonimizacion analitica | El `id_cliente_token` (SHA-256) es el unico identificador que puede circular fuera del perimetro MDM hacia el Data Lake |

---

## 7. Diagrama conceptual (Visual Paradigm)

[VP: exportar SVG aqui - modelo conceptual UML/ER con entidades Cliente, PuntoSuministro, ZonaGeografica y sus relaciones]

Ver modelo logico completo en [ArqDat/arquitectura.md](../ArqDat/arquitectura.md).
