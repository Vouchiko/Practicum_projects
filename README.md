# Practicum projects — SQL / Python / DataLens
Сборник учебных проектов по аналитике данных: SQL‑задачи, аналитика/статистика в Python и дашборды в Yandex DataLens.

<a id="toc"></a>
## Оглавление
- [Инструменты](#tools)
  - [SQL](#sql)
  - [Python](#python)
  - [DataLens](#datalens)
- [Структура корня](#root-structure)
- [Как запускать/открывать](#usage)
- [Папки в репозитории](#folders)
  - [`Python`](#folder-python)
  - [`SQL`](#folder-sql)
  - [`Yandex.Datalens`](#folder-datalens)

<a id="tools"></a>
## Инструменты

<a id="sql"></a>
### SQL
- [SQL · Проект](#sql-project) — итоговый SQL‑проект: ad hoc запросы по БД недвижимости `real_estate` + DataLens‑дашборд.
- [SQL · Извлечение данных](#sql-extract) — набор решений `1…16` (`*.sql`) + постановка в `README.md`.
- [SQL · Обработка данных](#sql-process) — задания в 2 частях (`1 часть/`, `2 часть/`) + постановка в `README.md`.
- [SQL · Анализ данных и ad hoc](#sql-adhoc) — проект «Секреты Темнолесья»: запросы + выводы.

<a id="python"></a>
### Python
- [Python · Предобработка данных](#python-preproc) — 2 задачи по подготовке датасетов (игры/стартапы).
- [Python · Исследовательский анализ и визуализация](#python-eda) — EDA по общепиту Москвы.
- [Python · Статистика](#python-stats) — проверки гипотез на данных GoFast.
- [Python · Инсайты](#python-insights) — воронка, RFM и кластеризация ресторанов.
- [Python · A/B‑тесты](#python-ab) — дизайн и анализ A/B(/C) экспериментов + дипломный кейс.

<a id="datalens"></a>
### DataLens
- Дашборд из SQL‑проекта: `https://datalens.yandex/iwhonc3ggirc4` (файл [`SQL/SQL. Проект/Ссылка на дашборд`](SQL/SQL.%20Проект/Ссылка%20на%20дашборд)).
- Дашборд из спринта DataLens: `https://datalens.yandex/p13as1icwe72b` (файл [`Yandex.Datalens/DataLens. Создание дашбордов/Ссылка на дашборд`](Yandex.Datalens/DataLens.%20Создание%20дашбордов/Ссылка%20на%20дашборд)).

<a id="root-structure"></a>
## Структура корня
```
Python/
SQL/
Yandex.Datalens/
```

<a id="usage"></a>
## Как запускать/открывать
- **Python**: откройте `*.ipynb` в Jupyter/VS Code и выполните ячейки по порядку (обычно используются `pandas`, `numpy`, `matplotlib`, `seaborn`, `scipy`, иногда `statsmodels/plotly/phik`).
- **SQL**: запускайте `*.sql` в SQL‑клиенте; в решениях встречается PostgreSQL‑синтаксис (`::type`, `FILTER`, `PERCENTILE_DISC`).
- **DataLens**: ссылки на дашборды лежат в файлах `Ссылка на дашборд` (доступ зависит от прав/аккаунта).

<a id="folders"></a>
## Папки в репозитории

<a id="folder-python"></a>
### `Python`
Подпроекты по Python (у большинства папок есть свой `README.md`).

<a id="python-preproc"></a>
#### Python · Предобработка данных
- Папка: `Python/Python. Предобработка данных`
- README: [`Python/Python. Предобработка данных/README.md`](Python/Python.%20Предобработка%20данных/README.md)
- Артефакты: `Python_preprocessing_1.ipynb`, `Python_preprocessing_2.ipynb`, `Задача_1.txt`, `Задача_2.txt`.

<a id="python-eda"></a>
#### Python · Исследовательский анализ и визуализация
- Папка: `Python/Python. Исслед. анализ и визуализация`
- README: [`Python/Python. Исслед. анализ и визуализация/README.md`](Python/Python.%20Исслед.%20анализ%20и%20визуализация/README.md)
- Артефакты: `Проект 7 спринта.ipynb`, `Задача.txt`.

<a id="python-stats"></a>
#### Python · Статистика
- Папка: `Python/Python. Статистика`
- README: [`Python/Python. Статистика/README.md`](Python/Python.%20Статистика/README.md)
- Артефакты: `Python_statistics.ipynb`, `task.txt`.

<a id="python-insights"></a>
#### Python · Инсайты
- Папка: `Python/Python. Инсайты`
- README: [`Python/Python. Инсайты/README.md`](Python/Python.%20Инсайты/README.md)
- Артефакты: `Python_Поиск_инсайтов.ipynb`.

<a id="python-ab"></a>
#### Python · A/B‑тесты
- Папка: `Python/Python. AB-тесты`
- README: [`Python/Python. AB-тесты/README.md`](Python/Python.%20AB-тесты/README.md)
- Артефакты: `Python_AB_tests_1.ipynb`, `Python_AB_tests_2.ipynb`, `Python_AB_tests_3.ipynb`, `Data_analysis_diploma.ipynb`.

<a id="folder-sql"></a>
### `SQL`
Подпроекты по SQL: задания оформлены как набор файлов `*.sql` + `README.md` с постановкой.

<a id="sql-project"></a>
#### SQL · Проект
- Папка: `SQL/SQL. Проект`
- README: [`SQL/SQL. Проект/README.md`](SQL/SQL.%20Проект/README.md)
- Артефакты: `Ad hoc запросы.sql`, `Ответы на вопросы.docx`, `Ссылка на дашборд` (`https://datalens.yandex/iwhonc3ggirc4`).

<a id="sql-extract"></a>
#### SQL · Извлечение данных
- Папка: `SQL/SQL. Извлечение данных`
- README: [`SQL/SQL. Извлечение данных/README.md`](SQL/SQL.%20Извлечение%20данных/README.md)
- Артефакты: `1 задание.sql` … `16 задание.sql`.

<a id="sql-process"></a>
#### SQL · Обработка данных
- Папка: `SQL/SQL. Обработка данных`
- README: [`SQL/SQL. Обработка данных/README.md`](SQL/SQL.%20Обработка%20данных/README.md)
- Артефакты: `1 часть/*.sql`, `2 часть/*.sql`.

<a id="sql-adhoc"></a>
#### SQL · Анализ данных и решение ad hoc задач
- Папка: `SQL/SQL. Анализ данных и решение ad hoc задач`
- README: [`SQL/SQL. Анализ данных и решение ad hoc задач/README.md`](SQL/SQL.%20Анализ%20данных%20и%20решение%20ad%20hoc%20задач/README.md)
- Артефакты: `Проект 4 спринта.sql`, `Проект спринта 4 Выводы.docx`.

<a id="folder-datalens"></a>
### `Yandex.Datalens`
- Папка: `Yandex.Datalens/DataLens. Создание дашбордов`
- Артефакты: `Ссылка на дашборд` (`https://datalens.yandex/p13as1icwe72b`).
