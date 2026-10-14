# 📊 Global Superstore: Business Intelligence & SQL Analytics

Proyecto de analítica de datos y resolución de problemas de negocio utilizando **SQL (SQLite)** sobre el conjunto de datos transaccional **Global Superstore**.

El objetivo de este repositorio es demostrar el uso progresivo de SQL —desde agregaciones y filtros básicos hasta el uso de CTEs encadenados, normalización de datos sucios en caliente y funciones de ventana analíticas— para responder preguntas críticas de rentabilidad, logística y comportamiento del cliente.

---

## 🛠️ Tecnologías y Conceptos Clave

- **Motor:** SQLite 3 (compatible con adaptaciones a PostgreSQL y SQL Server).
- **Técnicas de Consulta:**
  - Common Table Expressions (CTEs encadenados y modulares).
  - Funciones de Ventana (`ROW_NUMBER()`, `DENSE_RANK()`, `OVER (PARTITION BY ...)`).
  - Limpieza y reestructuración de cadenas y fechas (`SUBSTR`, `TRIM`, `LENGTH`, `julianday`).
  - Agregaciones condicionales (`SUM(CASE WHEN ...)`), `GROUP BY` y filtros con `HAVING`.
  - Tratamiento de granularidad y desduplicación de identidades (`DISTINCT`, `MIN()`).

---

## 📁 Estructura del Repositorio

```text
├── data/
│   └── Global_Superstore.csv       # Dataset fuente (o instrucciones de descarga)
├── queries/
│   ├── 01_basic_aggregations.sql   # Nivel 1: Filtros y agregaciones
│   ├── 02_intermediate_logic.sql   # Nivel 2: Métricas comerciales y márgenes
│   ├── 03_advanced_analytics.sql   # Nivel 3: CTEs, rankings y fechas
│   └── 04_expert_cohorts.sql       # Nivel 4: Canibalización y retención
└── README.md                       # Documentación del proyecto
```

---

## 📈 Resumen de Consultas e Insights de Negocio

### Nivel 1: Rendimiento Base y Filtrado Operativo
* **Rendimiento por Categoría:** Consolidación de ventas (`Sales`), beneficio neto (`Profit`) y unidades (`Quantity`) para evaluar las líneas troncales de producto.
* **Detección de Subcategorías en Pérdida:** Uso de `HAVING` y CTEs para aislar segmentos del catálogo con margen negativo total acumulado.
* **Envíos Críticos Inmediatos:** Identificación de órdenes únicas bajo modalidad `Same Day` y prioridad `Critical`, asegurando la no duplicidad por ítem (`DISTINCT`).

### Nivel 2: Métricas Comerciales y Segmentación
* **Margen Porcentual por Región:** Cálculo de ratio $\frac{\sum \text{Profit}}{\sum \text{Sales}} \times 100$ con umbral de facturación acumulada (`HAVING SUM(sales) > 50000`).
* **Impacto del Descuento Agresivo:** Segmentación de transacciones ($\ge 20\%$ vs $< 20\%$) evaluando ticket promedio y ganancia media.  
  > **Insight:** Descuentos a partir del 20% erosionan severamente el margen unitario, convirtiendo ventas de alto volumen en pérdidas operativas netas.
* **Clientes Frecuentes y Consolidación de IDs:** Identificación de compradores recurrentes ($> 15$ pedidos únicos), resolviendo anomalías de clientes con múltiples IDs asignados mediante agrupación por nombre y consolidación de identificadores.

### Nivel 3: Análisis Avanzado, Fechas y Rankings
* **Top 3 Productos por Subcategoría:** Implementación de CTEs encadenados y funciones de ventana (`ROW_NUMBER() OVER (PARTITION BY sub_category ORDER BY VentasTotales DESC)`) para segmentar los productos más vendidos por vertical.
* **Clientes de Alto Volumen pero No Rentables:** Aislamiento de cuentas con facturación mayor a 5,000 pero margen acumulado negativo, identificando clientes con alta demanda de soporte comercial y subsidios de envío perjudiciales.
* **Tiempos de Despacho Promedio por Mercado:** Limpieza y parseo dinámico de fechas en formato variable (`DD MM YYYY` a `YYYY-MM-DD`) mediante `SUBSTR` y `julianday()`, calculando el tiempo de despacho medio a nivel de orden única por región.

### Nivel 4: Patrones Complejos y Retención
* **Tasa de Canibalización por Descuento:** Detección de productos donde más del 50% de las ventas con descuento devuelven beneficio negativo.
* **Análisis de Recompra (Cohortes):** Cálculo del lapso entre la primera y segunda orden para medir tiempos de activación de clientes nuevos.
* **Costo de Envío Desproporcionado:** Auditoría sobre transacciones donde el flete (`Shipping Cost`) supera el 40% del ticket facturado.

---

## 💻 Ejemplo Destacado: CTEs Encadenados y Limpieza de Fechas

Consulta utilizada para normalizar fechas con variabilidad en longitud de caracteres y calcular el promedio real de días de despacho por mercado:

```sql
WITH FechasNormalizadas AS (
    SELECT DISTINCT
        order_id,
        market,
        CASE WHEN LENGTH(TRIM(order_date)) = 9 THEN '0' || TRIM(order_date) ELSE TRIM(order_date) END AS o_date,
        CASE WHEN LENGTH(TRIM(ship_date)) = 9 THEN '0' || TRIM(ship_date) ELSE TRIM(ship_date) END AS s_date
    FROM Data_ecommerce
),
DiasEnvio AS (
    SELECT 
        order_id,
        market,
        CAST(
            julianday(SUBSTR(s_date, 7, 4) || '-' || SUBSTR(s_date, 4, 2) || '-' || SUBSTR(s_date, 1, 2)) -
            julianday(SUBSTR(o_date, 7, 4) || '-' || SUBSTR(o_date, 4, 2) || '-' || SUBSTR(o_date, 1, 2))
        AS INT) AS DiasEnvio
    FROM FechasNormalizadas
)
SELECT 
    market AS Mercado,
    ROUND(AVG(DiasEnvio), 2) AS PromedioDias
FROM DiasEnvio
GROUP BY market
ORDER BY PromedioDias DESC;
```

---

## 🚀 Cómo Reproducir este Proyecto

1. Clona el repositorio:
   ```bash
   git clone https://github.com/tu-usuario/global-superstore-sql-analytics.git
   ```
2. Carga el archivo CSV en tu base de datos SQLite (usando SQLite CLI, DBeaver, DB Browser for SQLite, etc.):
   ```sql
   .mode csv
   .import data/Global_Superstore.csv Data_ecommerce
   ```
3. Ejecuta los scripts ubicados en la carpeta `/queries` en el orden de los módulos.
