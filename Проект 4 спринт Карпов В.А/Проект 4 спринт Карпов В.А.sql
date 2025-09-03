/* Проект «Секреты Тёмнолесья»
 * Цель проекта: изучить влияние характеристик игроков и их игровых персонажей 
 * на покупку внутриигровой валюты «райские лепестки», а также оценить 
 * активность игроков при совершении внутриигровых покупок
 * 
 * Автор: Карпов Владимир Алексеевич
 * Дата: 02.04.2025
*/

-- Часть 1. Исследовательский анализ данных
-- Задача 1. Исследование доли платящих игроков

-- 1.1. Доля платящих пользователей по всем данным:
SELECT 
    COUNT(DISTINCT u.id) AS total_player_count, -- общее число игроков,
    COUNT(DISTINCT u.id) FILTER (WHERE u.payer = 1), AS paying_player -- платящие игроки,
    ROUND(COUNT(DISTINCT u.id) FILTER (WHERE u.payer = 1) 
        / COUNT(DISTINCT u.id)::NUMERIC, 4) AS part_of_paying -- доля платящих игроков
FROM fantasy.users u;

-- 1.2. Доля платящих пользователей в разрезе расы персонажа:
SELECT 
    r.race,
    COUNT(DISTINCT u.id) AS total_player_count,
    COUNT(DISTINCT u.id) FILTER (WHERE u.payer = 1) AS paying_player,
    ROUND(COUNT(DISTINCT u.id) FILTER (WHERE u.payer = 1) 
        / COUNT(DISTINCT u.id)::NUMERIC, 4) AS part_of_paying
FROM fantasy.users u
JOIN fantasy.race r ON u.race_id = r.race_id
GROUP BY r.race 
ORDER BY part_of_paying DESC;
	

-- Задача 2. Исследование внутриигровых покупок
-- 2.1. Статистические показатели по полю amount:
SELECT 
	COUNT(*) AS total_player_count,
	SUM(amount) AS total_sum,
	MIN(amount) FILTER(WHERE amount > 0) AS min_amount,
	MAX(amount) AS max_amount,
	ROUND(AVG(amount)::NUMERIC, 4) AS avg_amount,
	PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY amount) AS mediana,
	ROUND(STDDEV(amount)::NUMERIC, 4) AS stand_dev
FROM fantasy.events

-- 2.2: Аномальные нулевые покупки:
SELECT 
  COUNT(*) FILTER (WHERE amount = 0) AS empty_count,
  COUNT(*) FILTER (WHERE amount = 0)::float / COUNT(*) AS part_of_empt
FROM fantasy.events;

-- 2.3: Сравнительный анализ активности платящих и неплатящих игроков:

SELECT 
    u.payer,
    COUNT(DISTINCT u.id) AS total_player_count,
    COUNT(e.transaction_id) AS total_purchases,
    ROUND(COUNT(e.transaction_id)::NUMERIC / NULLIF(COUNT(DISTINCT u.id), 0), 2) AS avg_purchases_per_player,
    ROUND(SUM(e.amount)::NUMERIC / NULLIF(COUNT(DISTINCT u.id), 0), 2) AS avg_amount_per_player
FROM fantasy.users u
LEFT JOIN fantasy.events e 
    ON u.id = e.id 
    AND e.amount > 0 -- исключаем нулевые транзакции
GROUP BY u.payer
ORDER BY u.payer;

  
-- 2.4: Популярные эпические предметы:
SELECT 
	i.game_items,
	COUNT(i.item_code) AS abs_purchases_count,
	COUNT(i.item_code) / (SELECT COUNT(*)
						FROM fantasy.events)::float AS relative_purchases_count,
	COUNT(DISTINCT e.id)/ (SELECT COUNT(DISTINCT e.id) 
						FROM fantasy.events e)::float AS part_of_users
	
FROM fantasy.events e
LEFT JOIN fantasy.items i USING (item_code)
GROUP BY game_items
ORDER BY abs_purchases_count DESC;
						

-- Часть 2. Решение ad hoc-задач
-- Задача 1. Зависимость активности игроков от расы персонажа:
--byer - купивший
--payer - платящий


--платящие игроки
WITH paying_users AS (
    SELECT 
    	DISTINCT u.id,
        r.race
    FROM fantasy.users u
    LEFT JOIN fantasy.race r ON u.race_id = r.race_id
    INNER JOIN fantasy.events e ON u.id = e.id AND e.amount > 0
    WHERE u.payer = 1
),

-- купившие игроки (те, у кого хотя бы одна покупка)
buying_users AS (
    SELECT 
        DISTINCT u.id,
        r.race
    FROM fantasy.users u
    LEFT JOIN fantasy.race r ON u.race_id = r.race_id
    INNER JOIN fantasy.events e ON u.id = e.id AND e.amount > 0
),
purchases AS (
    SELECT 
        u.id,
        r.race,
        COUNT(e.id) AS purchase_count,
        SUM(e.amount) AS total_spent
    FROM fantasy.users u
    LEFT JOIN fantasy.race r ON u.race_id = r.race_id
    LEFT JOIN fantasy.events e ON u.id = e.id AND e.amount > 0
    
    GROUP BY u.id, r.race
),
stats AS (
    SELECT 
        r.race,
        COUNT(DISTINCT u.id) AS total_players,
        COUNT(DISTINCT p.id) AS paying_players, -- платящие,
        COUNT(DISTINCT b.id) AS buying_players, -- купившие 
        SUM(pr.purchase_count) AS total_purchases,
        SUM(pr.total_spent) AS total_revenue
    FROM fantasy.users u
    LEFT JOIN fantasy.race r ON u.race_id = r.race_id
    LEFT JOIN paying_users p ON u.id = p.id
    LEFT JOIN buying_users b ON u.id = b.id
    LEFT JOIN purchases pr ON u.id = pr.id
    GROUP BY r.race
)

SELECT 
    race,
    total_players,
    paying_players,
    buying_players, -- добавил поле количества купивших игроков
    
    ROUND(buying_players::NUMERIC / NULLIF(total_players, 0), 4) AS buying_share_of_total, --доля купивших отн. всех,
    ROUND(paying_players::NUMERIC / NULLIF(buying_players, 0), 4) AS paying_share_of_bying, -- доля платящих отн. купивших,
    ROUND(total_purchases::NUMERIC / NULLIF(buying_players, 0), 2) AS avg_purchases_per_paying_player,
    ROUND(total_revenue::NUMERIC / NULLIF(total_purchases, 0), 2) AS avg_price_per_purchase,
    ROUND(total_revenue::NUMERIC / NULLIF(buying_players, 0), 2) AS avg_total_revenue_per_paying_player
FROM stats
ORDER BY race;

-- Честно говоря, немного запутался с определениями плятщих и купивших, надеюсь, правильно понял
