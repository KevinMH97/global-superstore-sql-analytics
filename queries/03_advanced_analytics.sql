-- 7.	Identificación de Clientes No Rentables:
/*Encuentra a los clientes cuyo volumen total de ventas supere los 5,000 en compras, pero cuya suma total de sea menor a 0 (generan mucho movimiento comercial pero genera pérdidas a la empresa).*/
WITH clienteNoRentables AS (
    SELECT 
        customer_id AS id,
        customer_name,
        SUM(sales) AS total,
        SUM(profit) AS Beneficio
    FROM Data_ecommerce
    GROUP BY customer_id, customer_name
)
SELECT 
    id,
    customer_name AS cliente,
    total,
    Beneficio
FROM clienteNoRentables
WHERE total > 5000 AND Beneficio < 0;

  
-- 8.	Tiempo Promedio de Envío por Mercado:
/*Calcula la cantidad promedio de días transcurridos entre Order Date y Ship Date para cada Market. Ordena para descubrir qué mercado tarda más en promedio en despachar sus pedidos.*/

WITH FechasNormalizadas AS (
    SELECT DISTINCT
        order_id,
        market,
        CASE 
            WHEN LENGTH(TRIM(order_date)) = 9 THEN '0' || TRIM(order_date) 
            ELSE TRIM(order_date) 
        END AS o_date,
        CASE 
            WHEN LENGTH(TRIM(ship_date)) = 9 THEN '0' || TRIM(ship_date) 
            ELSE TRIM(ship_date) 
        END AS s_date
    FROM Data_ecommerce
),
DiasEnvio AS (
    SELECT 
        order_id,
        market,
        CAST(
            JULIANDAY(SUBSTR(s_date, 7, 4) || '-' || SUBSTR(s_date, 4, 2) || '-' || SUBSTR(s_date, 1, 2)) -
            JULIANDAY(SUBSTR(o_date, 7, 4) || '-' || SUBSTR(o_date, 4, 2) || '-' || SUBSTR(o_date, 1, 2))
            AS INT
        ) AS DiasEnvio
    FROM FechasNormalizadas
)
SELECT 
    market AS Mercado,
    ROUND(AVG(DiasEnvio), 2) AS PromedioDias
FROM DiasEnvio
GROUP BY market
ORDER BY PromedioDias DESC;
