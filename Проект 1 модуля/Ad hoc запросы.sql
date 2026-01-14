-- 1 ad-hoc "Задача 1. Время активности объявлений"

WITH limits AS (
    SELECT  
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY total_area) AS total_area_limit,
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY rooms) AS rooms_limit,
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY balcony) AS balcony_limit,
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY ceiling_height) AS ceiling_height_limit_h,
        PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY ceiling_height) AS ceiling_height_limit_l
    FROM real_estate.flats     
),
filtered_id AS(
    SELECT id
    FROM real_estate.flats  
    WHERE 
        total_area < (SELECT total_area_limit FROM limits)
        AND (rooms < (SELECT rooms_limit FROM limits) OR rooms IS NULL)
        AND (balcony < (SELECT balcony_limit FROM limits) OR balcony IS NULL)
        AND ((ceiling_height < (SELECT ceiling_height_limit_h FROM limits)
            AND ceiling_height > (SELECT ceiling_height_limit_l FROM limits)) OR ceiling_height IS NULL)
),
categorized_data AS (
	SELECT f.*, 
	round((a.last_price::numeric / total_area::NUMERIC),2) AS meter_cost,
	CASE 
		WHEN city_id = '6X8I' THEN 'Санкт-Петербург'
		ELSE 'ЛенОбл'
	END AS region,
	CASE 
		WHEN a.days_exposition BETWEEN 1 AND 30 THEN 'Месяц'
		WHEN a.days_exposition BETWEEN 31 AND 90 THEN 'Квартал'
		WHEN a.days_exposition BETWEEN 91 AND 180 THEN 'Полгода'
		WHEN a.days_exposition > 180 THEN 'Больше полугода'
	END AS exposition_period
	
	FROM real_estate.flats f
	LEFT JOIN real_estate.advertisement a USING (id)
	LEFT JOIN real_estate."type" t using(type_id)
	WHERE id IN (SELECT * FROM filtered_id) AND t.type_id = 'F8EM' -- Добавил фильтр городов
)

SELECT
	region AS "Регион",
	exposition_period AS "Сегмент активности", 
	count (*) AS "Количество объявлений",
	round(avg(meter_cost), 2) AS "Средняя стоимость кв. метра",
	round (avg(total_area::NUMERIC), 2) AS "Средняя площадь",
	percentile_disc (0.5) WITHIN GROUP (ORDER BY rooms) AS "Медиана кол-ва комнат",
	percentile_disc (0.5) WITHIN GROUP (ORDER BY balcony) AS "Медиана кол-ва балконов",
	percentile_disc (0.5) WITHIN GROUP (ORDER BY floor) AS "Медиана кол-ва этажности"
FROM categorized_data
GROUP BY region, exposition_period
ORDER BY "Количество объявлений"
-------------------------------------------------------

-- 2 ad-hoc "Задача 2. Сезонность объявлений"

WITH limits AS (
    SELECT  
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY total_area) AS total_area_limit,
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY rooms) AS rooms_limit,
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY balcony) AS balcony_limit,
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY ceiling_height) AS ceiling_height_limit_h,
        PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY ceiling_height) AS ceiling_height_limit_l
    FROM real_estate.flats     
),
filtered_id AS(
    SELECT id
    FROM real_estate.flats  
    WHERE 
        total_area < (SELECT total_area_limit FROM limits)
        AND (rooms < (SELECT rooms_limit FROM limits) OR rooms IS NULL)
        AND (balcony < (SELECT balcony_limit FROM limits) OR balcony IS NULL)
        AND ((ceiling_height < (SELECT ceiling_height_limit_h FROM limits)
            AND ceiling_height > (SELECT ceiling_height_limit_l FROM limits)) OR ceiling_height IS NULL)
    ),
calculated_data AS (
	SELECT f.*,
		a.last_price::numeric / total_area AS meter_cost,
		a.first_day_exposition,
		(a.first_day_exposition::DATE +  (a.days_exposition || 'days')::INTERVAL)::date  AS last_day_exposition,
		a.days_exposition
		
	FROM real_estate.flats f
	LEFT JOIN real_estate.advertisement a USING(id)
	LEFT JOIN real_estate."type" t using(type_id)
	WHERE id IN (SELECT * FROM filtered_id) AND t.type_id = 'F8EM' AND 
		EXTRACT (YEAR FROM first_day_exposition) BETWEEN 2015 AND 2018 -- Добавил фильтр городов и года
	
), 
classificated_data AS (
	SELECT cd.*,
		EXTRACT (MONTH FROM first_day_exposition) AS first_month,
		EXTRACT (MONTH FROM last_day_exposition) AS last_month
	FROM calculated_data cd )

SELECT first_month,
	count(first_month) AS "Кол-во регистраций",
	count(last_month) AS "кол-во снятий",
	round(avg(meter_cost)::numeric,2) AS "Средняя стоимость кв. метра",
	round(avg(total_area)::NUMERIC,2) AS "Средняя площадь"
FROM classificated_data
GROUP BY first_month
ORDER BY first_month
-------------------------------------------------------

-- 3 ad-hoc "Задача 3. Анализ рынка недвижимости Ленобласти"

WITH limits AS (
    SELECT  
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY total_area) AS total_area_limit,
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY rooms) AS rooms_limit,
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY balcony) AS balcony_limit,
        PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY ceiling_height) AS ceiling_height_limit_h,
        PERCENTILE_DISC(0.01) WITHIN GROUP (ORDER BY ceiling_height) AS ceiling_height_limit_l
    FROM real_estate.flats     
),
filtered_id AS (
    SELECT id
    FROM real_estate.flats  
    WHERE 
        total_area < (SELECT total_area_limit FROM limits)
        AND (rooms < (SELECT rooms_limit FROM limits) OR rooms IS NULL)
        AND (balcony < (SELECT balcony_limit FROM limits) OR balcony IS NULL)
        AND ((ceiling_height < (SELECT ceiling_height_limit_h FROM limits)
              AND ceiling_height > (SELECT ceiling_height_limit_l FROM limits))
             OR ceiling_height IS NULL)
),
calculated_data AS (
    SELECT 
        f.id,
        f.city_id AS flat_city_id,
        f.total_area,
        f.rooms,
        f.balcony,
        f.ceiling_height,
        a.last_price::numeric / f.total_area AS meter_cost,
        a.first_day_exposition,
        (a.first_day_exposition::DATE 
         + (a.days_exposition||' days')::INTERVAL)::date  AS last_day_exposition,
        a.days_exposition
    FROM real_estate.flats f
    LEFT JOIN real_estate.advertisement a ON f.id = a.id
    WHERE f.id IN (SELECT id FROM filtered_id)
),
classificated_data AS (
    SELECT
        cd.*,
        EXTRACT(MONTH FROM cd.first_day_exposition)  AS first_month,
        EXTRACT(MONTH FROM cd.last_day_exposition)   AS last_month
    FROM calculated_data cd
),
town_activity AS (
    SELECT
        cd.flat_city_id AS city_id,
        COUNT(*) AS total_ads,
        COUNT(*) FILTER (WHERE cd.last_day_exposition <= CURRENT_DATE) AS removed_ads,
        AVG(cd.meter_cost) AS avg_meter_cost,
        AVG(cd.total_area) AS avg_area,
        AVG(cd.days_exposition) AS avg_duration
    FROM classificated_data cd
    GROUP BY cd.flat_city_id
    HAVING COUNT(*) > 50  
)
SELECT
    ta.city_id,
    c.city AS "Населённый пункт",
    ta.total_ads AS "Общее количество объявлений",
    ta.removed_ads AS "Снятые объявления",
    ROUND(ta.removed_ads::numeric/ta.total_ads*100,2) AS "Доля снятых объявлений (%)",
    ROUND(ta.avg_meter_cost::numeric,2) AS "Сред. стоимость кв. метра",
    ROUND(ta.avg_area::numeric,2) AS "Сред. площадь квартиры",
    ROUND(ta.avg_duration::numeric,2) AS "Сред. прод. публикации"
FROM town_activity ta
JOIN real_estate.city c ON c.city_id = ta.city_id
WHERE c.city_id <> '6X8I' -- Фильтр Санкт-Петербурга
ORDER BY "Доля снятых объявлений (%)" DESC
LIMIT 15;  

