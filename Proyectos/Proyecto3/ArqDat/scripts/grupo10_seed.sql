-- ============================================================
-- EnergiTech — Grupo10
-- SEED DATA: Datos de prueba para medición de calidad (P4)
-- Servidor Spartan 172.20.48.70:3306
-- Ejecutar DESPUÉS de grupo10_ddl.sql
-- ============================================================
-- PROPÓSITO: Simular los problemas reales de calidad del dato
-- descritos en el enunciado de EnergiTech:
--   - Registros incompletos (campos NULL en atributos obligatorios)
--   - Inconsistencias de formato (CUPS mal formados)
--   - Lecturas de consumo anómalas o fuera de rango
--   - Previsiones con MAPE fuera de umbral
-- ============================================================

USE Grupo10;

-- ============================================================
-- 1. ZONAS GEOGRÁFICAS
-- ============================================================

INSERT INTO dim_zona_geografica (codigo_zona, nombre, estacion_aemet_ref) VALUES
    ('ZN-MAD-001', 'Madrid Centro',       'AEMET-3195'),
    ('ZN-MAD-002', 'Madrid Sur',          'AEMET-3196'),
    ('ZN-VAL-001', 'Valencia Norte',      'AEMET-8416'),
    ('ZN-BAR-001', 'Barcelona Litoral',   'AEMET-0201'),
    ('ZN-SEV-001', 'Sevilla Metropolitana','AEMET-5783');

-- ============================================================
-- 2. VERSIONES DEL MODELO IA
-- ============================================================

INSERT INTO version_modelo (version, fecha_entrenamiento, mape_validation, hyperparameters) VALUES
    ('ET-MOD-PRED-001-v1.0', '2026-01-15 08:00:00', 8.4,
     '{"n_estimators": 200, "max_depth": 6, "learning_rate": 0.05}'),
    ('ET-MOD-PRED-001-v1.1', '2026-03-01 09:30:00', 7.2,
     '{"n_estimators": 300, "max_depth": 8, "learning_rate": 0.03}'),
    -- Versión con MAPE demasiado alto — marcada como inválida en el proceso
    ('ET-MOD-PRED-001-v0.9', '2025-11-10 10:00:00', 9.8,
     '{"n_estimators": 100, "max_depth": 4, "learning_rate": 0.1}');

-- ============================================================
-- 3. MAESTRO DE CLIENTES (Golden Records MDM)
-- Mezcla de registros completos, incompletos y problemáticos
-- para que M-COM-02 devuelva un valor < 1.0
-- ============================================================

INSERT INTO maestro_cliente
    (id_cliente_maestro, id_nacional, id_cliente_token, nombre_normalizado,
     tipo_cliente, sla_reforzado, estado, email_verificado, fecha_alta_maestra)
VALUES
    -- Clientes completos y correctos
    ('a1b2c3d4-0001-0001-0001-000000000001', '12345678A',
     SHA2(CONCAT('a1b2c3d4-0001-0001-0001-000000000001', 'et_salt_2026'), 256),
     'Juan Perez Garcia', 'RES', 0, 'ACTIVO', 'juan.perez@correo.es', '2022-03-15'),

    ('a1b2c3d4-0002-0002-0002-000000000002', '87654321B',
     SHA2(CONCAT('a1b2c3d4-0002-0002-0002-000000000002', 'et_salt_2026'), 256),
     'Hospital General Madrid', 'CRIT', 1, 'ACTIVO', 'suministros@hospitalgeneral.es', '2020-01-10'),

    ('a1b2c3d4-0003-0003-0003-000000000003', '11223344C',
     SHA2(CONCAT('a1b2c3d4-0003-0003-0003-000000000003', 'et_salt_2026'), 256),
     'Industrias Metalicas SA', 'IND', 0, 'ACTIVO', 'energia@metalicas-sa.com', '2021-06-20'),

    ('a1b2c3d4-0004-0004-0004-000000000004', '44332211D',
     SHA2(CONCAT('a1b2c3d4-0004-0004-0004-000000000004', 'et_salt_2026'), 256),
     'Maria Lopez Fernandez', 'RES', 0, 'ACTIVO', 'maria.lopez@email.com', '2023-09-01'),

    ('a1b2c3d4-0005-0005-0005-000000000005', '55667788E',
     SHA2(CONCAT('a1b2c3d4-0005-0005-0005-000000000005', 'et_salt_2026'), 256),
     'Centro Datos CloudTech', 'CRIT', 1, 'ACTIVO', 'ops@cloudtech.es', '2019-11-30'),

    -- ⚠️ PROBLEMA DE CALIDAD: email_verificado NULL → afecta M-COM-02
    -- Impacto: sin email no se puede aplicar la regla de matching RM-02
    ('a1b2c3d4-0006-0006-0006-000000000006', '66778899F',
     SHA2(CONCAT('a1b2c3d4-0006-0006-0006-000000000006', 'et_salt_2026'), 256),
     'Carlos Ruiz Martinez', 'RES', 0, 'ACTIVO', NULL, '2024-02-14'),

    -- ⚠️ PROBLEMA DE CALIDAD: id_nacional NULL → afecta M-COM-02
    -- Impacto: sin DNI no se puede aplicar la regla de matching RM-01
    ('a1b2c3d4-0007-0007-0007-000000000007', NULL,
     SHA2(CONCAT('a1b2c3d4-0007-0007-0007-000000000007', 'et_salt_2026'), 256),
     'Almacenes Logisticos SL', 'IND', 0, 'SUSPENDIDO', 'admin@almacenes-sl.com', '2023-05-18'),

    -- ⚠️ PROBLEMA DE CALIDAD: id_nacional Y email NULL → registro casi inútil para MDM
    ('a1b2c3d4-0008-0008-0008-000000000008', NULL,
     SHA2(CONCAT('a1b2c3d4-0008-0008-0008-000000000008', 'et_salt_2026'), 256),
     'Cliente Desconocido', 'RES', 0, 'SUSPENDIDO', NULL, '2024-07-01'),

    -- Clientes adicionales completos
    ('a1b2c3d4-0009-0009-0009-000000000009', '99887766G',
     SHA2(CONCAT('a1b2c3d4-0009-0009-0009-000000000009', 'et_salt_2026'), 256),
     'Residencia Mayores Esperanza', 'CRIT', 1, 'ACTIVO', 'direcc@residencia-esp.es', '2021-03-22'),

    ('a1b2c3d4-0010-0010-0010-000000000010', '10203040H',
     SHA2(CONCAT('a1b2c3d4-0010-0010-0010-000000000010', 'et_salt_2026'), 256),
     'Ana Garcia Moreno', 'RES', 0, 'BAJA', 'ana.garcia@personal.com', '2022-08-11');

-- ============================================================
-- 4. MAPEO DE IDs LEGADOS
-- Refleja la fragmentación real de EnergiTech
-- ============================================================

-- Variables para los tokens (usamos subconsultas para obtenerlos)
INSERT INTO mapeo_ids_legados (id_cliente_maestro, sistema_origen, id_legado, estado_matching) VALUES
    -- Juan Pérez aparecía en los 3 sistemas con IDs distintos
    ('a1b2c3d4-0001-0001-0001-000000000001', 'CRM',     'LUZ-0123',  'FUSION_AUTO'),
    ('a1b2c3d4-0001-0001-0001-000000000001', 'SAP-ISU', 'GAS-0321',  'FUSION_AUTO'),
    ('a1b2c3d4-0001-0001-0001-000000000001', 'ERP',     'MANT-1230', 'REVISION_MANUAL'),
    -- Hospital General — solo en CRM y SAP-ISU
    ('a1b2c3d4-0002-0002-0002-000000000002', 'CRM',     'LUZ-0456',  'FUSION_AUTO'),
    ('a1b2c3d4-0002-0002-0002-000000000002', 'SAP-ISU', 'GAS-0654',  'FUSION_AUTO'),
    -- Resto de clientes — un ID por sistema
    ('a1b2c3d4-0003-0003-0003-000000000003', 'CRM',     'LUZ-0789',  'FUSION_AUTO'),
    ('a1b2c3d4-0004-0004-0004-000000000004', 'CRM',     'LUZ-1011',  'FUSION_AUTO'),
    ('a1b2c3d4-0005-0005-0005-000000000005', 'CRM',     'LUZ-1213',  'FUSION_AUTO'),
    ('a1b2c3d4-0006-0006-0006-000000000006', 'CRM',     'LUZ-1415',  'FUSION_AUTO'),
    ('a1b2c3d4-0007-0007-0007-000000000007', 'ERP',     'MANT-9999', 'DUPLICADO_POTENCIAL'),
    ('a1b2c3d4-0009-0009-0009-000000000009', 'CRM',     'LUZ-1617',  'FUSION_AUTO'),
    ('a1b2c3d4-0010-0010-0010-000000000010', 'CRM',     'LUZ-1819',  'FUSION_AUTO');

-- ============================================================
-- 5. PUNTOS DE SUMINISTRO
-- ============================================================

-- Necesitamos los tokens para las FK — usamos subconsultas
INSERT INTO dim_punto_suministro
    (cups, id_cliente_token, codigo_zona, potencia_contratada, fecha_alta, estado)
SELECT
    'ES0021000000000001JN',
    id_cliente_token, 'ZN-MAD-001', 5.75, '2022-03-15', 'ACTIVO'
FROM maestro_cliente WHERE id_nacional = '12345678A'

UNION ALL SELECT
    'ES0021000000000002AB',
    id_cliente_token, 'ZN-MAD-001', 350.00, '2020-01-10', 'ACTIVO'
FROM maestro_cliente WHERE id_nacional = '87654321B'

UNION ALL SELECT
    'ES0031000000000003CD',
    id_cliente_token, 'ZN-VAL-001', 125.50, '2021-06-20', 'ACTIVO'
FROM maestro_cliente WHERE id_nacional = '11223344C'

UNION ALL SELECT
    'ES0041000000000004EF',
    id_cliente_token, 'ZN-BAR-001', 3.45, '2023-09-01', 'ACTIVO'
FROM maestro_cliente WHERE id_nacional = '44332211D'

UNION ALL SELECT
    'ES0051000000000005GH',
    id_cliente_token, 'ZN-MAD-002', 500.00, '2019-11-30', 'ACTIVO'
FROM maestro_cliente WHERE id_nacional = '55667788E'

UNION ALL SELECT
    'ES0061000000000006IJ',
    id_cliente_token, 'ZN-SEV-001', 4.60, '2024-02-14', 'ACTIVO'
FROM maestro_cliente WHERE id_nacional = '66778899F'

UNION ALL SELECT
    'ES0091000000000009QR',
    id_cliente_token, 'ZN-MAD-001', 75.00, '2021-03-22', 'ACTIVO'
FROM maestro_cliente WHERE id_nacional = '99887766G'

-- ⚠️ PROBLEMA DE CALIDAD: CUPS con formato incorrecto → afecta M-CON-02
-- Falta el sufijo de dos letras mayúsculas (solo tiene 20 chars en vez de 22)
-- Nota: el CHECK constraint de MySQL 8 rechazará este INSERT — está aquí
-- deliberadamente para documentar el problema detectado en auditoría.
-- En un entorno real, este registro existe en el sistema fuente sin validación.
-- UNION ALL SELECT
--     'ES002100000000000XYZ',   -- ← formato incorrecto (solo para documentación)
--     id_cliente_token, 'ZN-MAD-002', 8.00, '2024-01-01', 'ACTIVO'
-- FROM maestro_cliente WHERE id_nacional = '10203040H';
-- El cliente 0010 tiene estado BAJA — no tiene punto de suministro activo

;

-- ============================================================
-- 6. LECTURAS DE CONSUMO HORARIO
-- Datos del mes de abril 2026 — muestra representativa
-- ============================================================

INSERT INTO fact_consumo_horario
    (id_cliente_token, cups, ts_lectura, consumo_kwh, calidad_lectura)

-- Cliente residencial normal (Juan Pérez) — lecturas correctas
SELECT id_cliente_token,
    'ES0021000000000001JN', '2026-04-01 00:00:00', 0.312, 'REAL'
FROM maestro_cliente WHERE id_nacional = '12345678A'
UNION ALL SELECT id_cliente_token,
    'ES0021000000000001JN', '2026-04-01 01:00:00', 0.198, 'REAL'
FROM maestro_cliente WHERE id_nacional = '12345678A'
UNION ALL SELECT id_cliente_token,
    'ES0021000000000001JN', '2026-04-01 02:00:00', 0.145, 'REAL'
FROM maestro_cliente WHERE id_nacional = '12345678A'
UNION ALL SELECT id_cliente_token,
    'ES0021000000000001JN', '2026-04-01 06:00:00', 0.587, 'REAL'
FROM maestro_cliente WHERE id_nacional = '12345678A'
UNION ALL SELECT id_cliente_token,
    'ES0021000000000001JN', '2026-04-01 08:00:00', 1.243, 'REAL'
FROM maestro_cliente WHERE id_nacional = '12345678A'
UNION ALL SELECT id_cliente_token,
    'ES0021000000000001JN', '2026-04-01 12:00:00', 1.876, 'REAL'
FROM maestro_cliente WHERE id_nacional = '12345678A'
UNION ALL SELECT id_cliente_token,
    'ES0021000000000001JN', '2026-04-01 20:00:00', 2.134, 'REAL'
FROM maestro_cliente WHERE id_nacional = '12345678A'

-- Hospital General (cliente crítico) — lecturas correctas alta potencia
UNION ALL SELECT id_cliente_token,
    'ES0021000000000002AB', '2026-04-01 00:00:00', 87.450, 'REAL'
FROM maestro_cliente WHERE id_nacional = '87654321B'
UNION ALL SELECT id_cliente_token,
    'ES0021000000000002AB', '2026-04-01 06:00:00', 125.300, 'REAL'
FROM maestro_cliente WHERE id_nacional = '87654321B'
UNION ALL SELECT id_cliente_token,
    'ES0021000000000002AB', '2026-04-01 12:00:00', 198.750, 'REAL'
FROM maestro_cliente WHERE id_nacional = '87654321B'
UNION ALL SELECT id_cliente_token,
    'ES0021000000000002AB', '2026-04-01 20:00:00', 156.200, 'REAL'
FROM maestro_cliente WHERE id_nacional = '87654321B'

-- ⚠️ PROBLEMA DE CALIDAD: consumo_kwh anómalo (>3x media) → afecta M-ACC-01
-- Pico extremo de consumo — posible error del sensor SCADA
UNION ALL SELECT id_cliente_token,
    'ES0021000000000002AB', '2026-04-15 14:00:00', 9999.999, 'ESTIMADA'
FROM maestro_cliente WHERE id_nacional = '87654321B'

-- Cliente industrial normal
UNION ALL SELECT id_cliente_token,
    'ES0031000000000003CD', '2026-04-01 00:00:00', 42.100, 'REAL'
FROM maestro_cliente WHERE id_nacional = '11223344C'
UNION ALL SELECT id_cliente_token,
    'ES0031000000000003CD', '2026-04-01 08:00:00', 98.750, 'REAL'
FROM maestro_cliente WHERE id_nacional = '11223344C'
UNION ALL SELECT id_cliente_token,
    'ES0031000000000003CD', '2026-04-01 16:00:00', 85.300, 'REAL'
FROM maestro_cliente WHERE id_nacional = '11223344C'

-- Cliente residencial (María López)
UNION ALL SELECT id_cliente_token,
    'ES0041000000000004EF', '2026-04-01 08:00:00', 0.756, 'REAL'
FROM maestro_cliente WHERE id_nacional = '44332211D'
UNION ALL SELECT id_cliente_token,
    'ES0041000000000004EF', '2026-04-01 20:00:00', 1.432, 'REAL'
FROM maestro_cliente WHERE id_nacional = '44332211D'

-- ⚠️ PROBLEMA DE CALIDAD: calidad_lectura = ESTIMADA (gap temporal)
-- La lectura de las 14h falta — se interpoló linealmente (control TV-03)
UNION ALL SELECT id_cliente_token,
    'ES0041000000000004EF', '2026-04-01 14:00:00', 0.987, 'ESTIMADA'
FROM maestro_cliente WHERE id_nacional = '44332211D'

-- Centro de datos (cliente crítico)
UNION ALL SELECT id_cliente_token,
    'ES0051000000000005GH', '2026-04-01 00:00:00', 215.300, 'REAL'
FROM maestro_cliente WHERE id_nacional = '55667788E'
UNION ALL SELECT id_cliente_token,
    'ES0051000000000005GH', '2026-04-01 12:00:00', 287.650, 'REAL'
FROM maestro_cliente WHERE id_nacional = '55667788E'

-- Carlos Ruiz (registro con email NULL)
UNION ALL SELECT id_cliente_token,
    'ES0061000000000006IJ', '2026-04-01 08:00:00', 0.654, 'REAL'
FROM maestro_cliente WHERE id_nacional = '66778899F'
UNION ALL SELECT id_cliente_token,
    'ES0061000000000006IJ', '2026-04-01 20:00:00', 1.123, 'REAL'
FROM maestro_cliente WHERE id_nacional = '66778899F'

-- Residencia de mayores (cliente crítico)
UNION ALL SELECT id_cliente_token,
    'ES0091000000000009QR', '2026-04-01 00:00:00', 32.450, 'REAL'
FROM maestro_cliente WHERE id_nacional = '99887766G'
UNION ALL SELECT id_cliente_token,
    'ES0091000000000009QR', '2026-04-01 12:00:00', 48.750, 'REAL'
FROM maestro_cliente WHERE id_nacional = '99887766G'
UNION ALL SELECT id_cliente_token,
    'ES0091000000000009QR', '2026-04-01 20:00:00', 41.200, 'REAL'
FROM maestro_cliente WHERE id_nacional = '99887766G'

-- ⚠️ PROBLEMA DE CALIDAD: consumo_kwh negativo → imposible físicamente
-- Simula un error de lectura del contador → afecta M-ACC-01
UNION ALL SELECT id_cliente_token,
    'ES0091000000000009QR', '2026-04-10 03:00:00', -5.000, 'ESTIMADA'
FROM maestro_cliente WHERE id_nacional = '99887766G'
;

-- ============================================================
-- 7. PREVISIONES DE DEMANDA
-- ============================================================

INSERT INTO fact_prevision_demanda
    (id_cliente_token, codigo_zona, version_modelo,
     mes_prevision, demanda_kwh, mape_modelo)

-- Previsiones válidas con v1.1 (MAPE ≤ 10%)
SELECT id_cliente_token,
    'ZN-MAD-001', 'ET-MOD-PRED-001-v1.1', '2026-05-01', 485.20, 6.8
FROM maestro_cliente WHERE id_nacional = '12345678A'
UNION ALL SELECT id_cliente_token,
    'ZN-MAD-001', 'ET-MOD-PRED-001-v1.1', '2026-05-01', 98450.00, 5.2
FROM maestro_cliente WHERE id_nacional = '87654321B'
UNION ALL SELECT id_cliente_token,
    'ZN-VAL-001', 'ET-MOD-PRED-001-v1.1', '2026-05-01', 52340.00, 7.1
FROM maestro_cliente WHERE id_nacional = '11223344C'
UNION ALL SELECT id_cliente_token,
    'ZN-BAR-001', 'ET-MOD-PRED-001-v1.1', '2026-05-01', 312.80, 8.9
FROM maestro_cliente WHERE id_nacional = '44332211D'
UNION ALL SELECT id_cliente_token,
    'ZN-MAD-002', 'ET-MOD-PRED-001-v1.1', '2026-05-01', 187650.00, 4.3
FROM maestro_cliente WHERE id_nacional = '55667788E'

-- ⚠️ PROBLEMA DE CALIDAD: MAPE > 10% → resultado no válido → afecta M-ACC-02
-- Se usó la versión v0.9 del modelo (la problemática) y el error es inaceptable
-- En el proceso real este registro no se publicaría; aquí lo incluimos
-- para que la métrica M-ACC-02 detecte el problema
UNION ALL SELECT id_cliente_token,
    'ZN-MAD-001', 'ET-MOD-PRED-001-v0.9', '2026-04-01', 28900.00, 9.8
FROM maestro_cliente WHERE id_nacional = '99887766G'
;

-- ============================================================
-- VERIFICACIÓN RÁPIDA
-- Ejecuta estas queries para confirmar que los datos se cargaron
-- ============================================================

SELECT 'maestro_cliente'      AS tabla, COUNT(*) AS registros FROM maestro_cliente
UNION ALL
SELECT 'mapeo_ids_legados',   COUNT(*) FROM mapeo_ids_legados
UNION ALL
SELECT 'dim_zona_geografica', COUNT(*) FROM dim_zona_geografica
UNION ALL
SELECT 'dim_punto_suministro',COUNT(*) FROM dim_punto_suministro
UNION ALL
SELECT 'version_modelo',      COUNT(*) FROM version_modelo
UNION ALL
SELECT 'fact_consumo_horario',COUNT(*) FROM fact_consumo_horario
UNION ALL
SELECT 'fact_prevision_demanda', COUNT(*) FROM fact_prevision_demanda;
