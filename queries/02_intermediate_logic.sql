-- 4.	Margen de Ganancia por Región:
/* Calcula el margen de ganancia porcentual promedio por, definido como: $$(SUM(Profit) / SUM(Sales)) \times 100$$ Filtra únicamente aquellas regiones que hayan vendido más de 50,000 en total.*/
SELECT
    region AS Región,
    SUM(sales) AS Totales,
    ROUND((SUM(profit) * 1.0 / SUM(sales)) * 100, 2) AS [Margen de Ganancia]
FROM Data_ecommerce
GROUP BY region
HAVING SUM(sales) > 50000;

-- 5.	Impacto de Descuentos Agresivos:
/*Clasifica las ventas en dos grupos usando una condición: transacciones con descuento alto (Discount >= 0.20) vs. descuento bajo o nulo (Discount < 0.20). Para cada grupo, calcula el ticket promedio 
de venta y la ganancia promedio.*/

SELECT 
	CASE
		WHEN discount >= 0.20 THEN 'Descuento Alto'
        ELSE 'Descuento Bajo' END AS clasificacion, 
  round(avg(sales), 2) AS [Ticket Promedio],
  round(avg(profit), 2) AS Ganacias
FROM Data_ecommerce
GROUP BY clasificacion
  
-- 6.	Clientes Frecuentes vs. Esporádicos:
/*Identifica los clientes que hayan realizado más de 15 pedidos distintos. Muestra además el monto total que han comprado a lo largo del tiempo.*/
  
SELECT
    customer_id AS id,
    customer_name AS Nombre,
    COUNT(DISTINCT order_id) AS [Pedidos Totales],
    ROUND(SUM(sales), 2) AS [Monto total]
FROM Data_ecommerce
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT order_id) > 15;
