-- ПРАКТИЧЕСКАЯ РАБОТА № 5
-- ВЫПОЛНЕННОЕ ПРАКТИЧЕСКОЕ ЗАДАНИЕ - ЭТО ФАЙЛ ФОРМАТА .SQL. 

-- ШАГ 1. ПРОСТЫЕ ВЫБОРКИ: ИЗ ОДНОЙ ТАБЛИЦЫ
-- 1.1 SELECT , LIMIT - ВЫБРАТЬ 5 ЗАПИСЕЙ ИЗ ТАБЛИЦЫ MOVIES

/* 
----------------------------------- РЕЗУЛЬТАТ -----------------------------------------------------
# ID, BUDGET, IMDB_ID, ORIGINAL_LANGUAGE, ORIGINAL_TITLE, POPULARITY, RELEASE_DATE, REVENUE, RUNTIME, TITLE, VOTE_AVERAGE, VOTE_COUNT, HOMEPAGE, OVERVIEW
577, 20000000, tt0114681, en, To Die For, 10.448481, 1995-05-20, 21284514, 106.0, To Die For, 6.7, 177, , Susan wants to work in television and will therefore do anything it takes, even if it means killing her husband. A very dark comedy from independent director Gus Van Sant with a brilliant Nicole Kidman in the leading role.
755, 19000000, tt0116367, en, From Dusk Till Dawn, 15.339153, 1996-01-19, 25836616, 108.0, From Dusk Till Dawn, 6.9, 1644, http://www.miramax.com/movie/from-dusk-till-dawn/, Seth Gecko and his younger brother Richard are on the run after a bloody bank robbery in Texas. They escape across the border into Mexico and will be home-free the next morning, when they pay off the local kingpin. They just have to survive 'from dusk till dawn' at the rendezvous point, which turns out to be a Hell of a strip joint.
880, 900000, tt0112379, nl, Antonia, 2.030174, 1995-09-12, 0, 102.0, Antonia's Line, 7.2, 26, , After World War II, Antonia and her daughter, Danielle, go back to their Dutch hometown, where Antonia's late mother has bestowed a small farm upon her. There, Antonia settles down and joins a tightly-knit but unusual community. Those around her include quirky friend Crooked Finger, would-be suitor Bas and, eventually for Antonia, a granddaughter and great-granddaughter who help create a strong family of empowered women.
949, 60000000, tt0113277, en, Heat, 17.924927, 1995-12-15, 187436818, 170.0, Heat, 7.7, 1886, , Obsessive master thief, Neil McCauley leads a top-notch crew on various insane heists throughout Los Angeles while a mentally unstable detective, Vincent Hanna pursues him without rest. Each man recognizes and respects the ability and the dedication of the other even though they are aware their cat-and-mouse game may end in violence.
710, 58000000, tt0113189, en, GoldenEye, 14.686036, 1995-11-16, 352194034, 130.0, GoldenEye, 6.6, 1194, http://www.mgm.com/view/movie/757/Goldeneye/, James Bond must unmask the mysterious head of the Janus Syndicate and prevent the leader from utilizing the GoldenEye weapons system to inflict devastating revenge on Britain.
*/


-- 1.2 WHERE, LIKE - ВЫБРАТЬ ИЗ ТАБЛИЦЫ LINKS ВСЁ ЗАПИСИ, У КОТОРЫХ IMDBID ОКАНЧИВАЕТСЯ НА "42", А ПОЛЕ MOVIEID МЕЖДУ 100 И 1000

/* 
----------------------------------- РЕЗУЛЬТАТ -----------------------------------------------------
# MOVIEID, IMDBID, TMDBID
987, 118742, 63945
988, 116442, 58985
145, 112442, 9737
146, 112342, 30765
158, 112642, 8839
582, 107642, 47507
703, 115742, 43634
*/

-- 1.3 DESC, ORDER BY, LIMIT - ВЫБРАТЬ ТОП-5 ФИЛЬМОВ C МАКСИМАЛЬНОМ ПРИБЫЛЬЮ (прибыль: доход REVENUE-бюджет BUDGET)

/* 
----------------------------------- РЕЗУЛЬТАТ -----------------------------------------------------
title, Прибыль
Titanic, 1645.0342
The Lord of the Rings: The Return of the King, 1024.8890
Pirates of the Caribbean: Dead Man's Chest, 865.6598
Jurassic Park, 857.1000
Harry Potter and the Philosopher's Stone, 851.4756 */



-- ШАГ 2. СЛОЖНЫЕ ВЫБОРКИ: ОБЪЕДИНЕНИЕ ТАБЛИЦ
-- 2.1  JOIN, DISTINCT - ВЫБРАТЬ ИЗ ТАБЛИЦЫ MOVIES УНИКАЛЬНЫЕ НАЗВАНИЯ ФИЛЬМОВ (TITLE), КОТОРЫМ СТАВИЛИ ОЦЕНКУ 5.
-- ВЫВЕСТИ ПЕРВЫЕ 5

 /* 
----------------------------------- РЕЗУЛЬТАТ -----------------------------------------------------
# TITLE
Once Were Warriors
Terminator Salvation
Men in Black II
The Hidden Fortress
Terminator 3: Rise of the Machines
*/


-- ШАГ 3. АГГРЕГАЦИЯ ДАННЫХ: БАЗОВЫЕ СТАТИСТИКИ
-- 3.1 COUNT(), DISTINCT - ПОСЧИТАТЬ КОЛИЧЕСТВО ФИЛЬМОВ, КОТОРЫМ СТАВИЛИ ОЦЕНКУ 1.

/* 
----------------------------------- РЕЗУЛЬТАТ -----------------------------------------------------
# Количество
281
*/


-- 3.2 GROUP BY, ORDER BY, COUNT() - ВЫВЕСТИ НАЗВАНИЯ ТОП-5 САМЫХ ПОПУЛЯРНЫХ ФИЛЬМОВ (TITLE) 
-- (ПОПУЛЯРНОСТЬ СЧИТАТЬ ПО КОЛИЧЕСТВУ ОЦЕНОК в таблице ratings)

/* 
----------------------------------- РЕЗУЛЬТАТ -----------------------------------------------------
# title, pop
Terminator 3: Rise of the Machines, 324
The Million Dollar Hotel, 311
Solaris, 304
The 39 Steps, 291
Monsoon Wedding, 274

*/

-- ШАГ 4. ИЕРАРХИЧЕСКИЕ ЗАПРОСЫ
-- 4.1 ПОДЗАПРОСЫ: ВЫВЕСТИ НАЗВАНИЯ И КОЛИЧЕСТВО ОЦЕНОК (ИЗ ТАБЛИЦЫ RATINGS) У ФИЛЬМОВ C МАКСИМАЛЬНЫМ СРЕДНИМ РЕЙТИНГОМ (VOTE_AVERAGE ИЗ ТАБЛИЦЫ MOVIES).

/* 
----------------------------------- РЕЗУЛЬТАТ -----------------------------------------------------
# TITLE, VOTE_AVERAGE, COUNT(rating)
The Godfather, 8.5, 5
The Shawshank Redemption, 8.5, 5

*/

-- ШАГ 5. ЗАГРУЗИТЬ ФАЙЛ РАСШИРЕНИЯ *.SQL НА ПЛАТФОРМУ ODIN.