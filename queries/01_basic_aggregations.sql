-- Nivel 1: Básico (Filtros, Agregaciones y Ordenamiento)
-- 1. Rendimiento por Categoría:

/* Calcula las ventas totales, la ganancia neta total y la cantidad total de artículos vendidos agrupados por Categoria. Ordena el resultado de mayor a menor ganancia.*/
SELECT
    category AS Categoria,
    SUM(sales) AS [Ventas Totales],
    SUM(profit) AS [Ganancias Totales],
    SUM(quantity) AS [Articulos Vendidos]
FROM Data_ecommerce
GROUP BY category
ORDER BY [Ganancias Totales] DESC;

-- 2. Detección de Subcategorías con Pérdidas:

/* Encuentra todas las Sub-Category que tengan un beneficio total negativo (pérdidas globales). Muestra el nombre de la subcategoría y el total acumulado de pérdidas.*/
WITH subcategoria AS (
    SELECT
        sub_category,
        SUM(profit) AS Ganancias
    FROM Data_ecommerce
    GROUP BY sub_category
)
SELECT 
    sub_category,
    Ganancias
FROM subcategoria
WHERE Ganancias < 0;

-- 3. Tiempos de Despacho Inmediato:

/* Obtén la lista de órdenes únicas enviadas bajo la modalidad Same Day que hayan tenido prioridad 'Critical', mostrando la fecha de orden y el cliente.*/
SELECT DISTINCT
    order_id,
    ship_mode AS Modalidad,
    order_priority AS Prioridad,
    order_date AS [Fecha de Orden],
    customer_name AS Cliente
FROM Data_ecommerce
WHERE ship_mode = 'Same Day' 
  AND order_priority = 'Critical';
