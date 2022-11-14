# Материалы для итоговой аттестации

## 📈 EDA анализ 

### 📂 Импорт библиотек

```
import pandas as pd
import numpy as np

import warnings
warnings.simplefilter("ignore")

import matplotlib.pyplot as plt
import seaborn as sns
import plotly.express as px
import plotly.graph_objects as go
from datetime import datetime

%matplotlib inline
%config InlineBackend.figure_format = 'retina'

from pylab import rcParams
sns.set_style("whitegrid", {'axes.grid' : True})
```

### 🗑 Очистка данных

**➡️ Проверить типы данных**
```
df.info()

# пример преобразования типов данных
df["Дата"] = pd.to_datetime(df["Дата"])
df['Количество'] = df['Количество'].astype(int)
# создаем новый столбец
df['Дата2'] = df['Дата'].dt.date
```

**➡️ Выделить список категориальных признаков**

```
categorical_columns = [c for c in df.columns if df[c].dtype.name == 'object']
numerical_columns   = [c for c in df.columns if df[c].dtype.name != 'object']
df[categorical_columns].describe()
df.describe(include=[object])
```

**➡️ Проверить на пустые значения**

```
df.isnull().sum()
```

**➡️ Заполнить пустые значения**

```
from sklearn.impute import SimpleImputer

imputer = SimpleImputer(missing_values = np.nan, strategy = 'most_frequent')
df["Признак 1"] = imputer.fit_transform(df["Признак 1"].values.reshape(-1,1))[:,0]
```

**➡️ Поиск и удаление дубликатов**
```
df.duplicated().sum()
df = df.drop_duplicates()
df.shape
```
**➡️ Поиск аномалий**
```
df.describe()

print('\033[1m'+ 'Уникальные значения'+'\033[0m'+'\n')
for i in df.columns.to_list():
    print('\033[91m'+ 'Признак {} имеет {} следующих уникальных значений:'.format(i, len(df[i].unique()))+'\033[0m')
    print(df[i].unique())
    print('\033[1m' + '---------------------------------------------------------------------------------'+ '\033[0m') 
```

### ✂️ Операции с датафреймом

```
import pandasql as ps

df2 = ps.sqldf("""SELECT Признак1, Признак2, Признак3
            FROM df1 """)
```

```
df2 = df1.groupby('Признак1').count().sort_values(['Признак2'],ascending=False)
```

```
df3 = df1.merge(df2, how='left', left_on='Признак1', right_on='Признак2') 
```

### 🧮 Описательная статистика

**➡️ Оценки центрального положения**

Основной этап исследования данных состоит в получении "типичного значения" для каждого признака (переменной): оценки того, где расположено большинство данных (т. е. их центральной тенденции).

```
stats.mean()
stats.median()
stats.moda() для оценки категориальных данных
```

**➡️ Оценки вариабельности**

```
df.describe()
```


### 📊 Визуализация
**➡️ sweetviz**
```
  !pip install sweetviz 

  import sweetviz as sv 

  my_report = sv.analyze(df) 
  my_report.show_html()
```

**➡️ Гистограмма**

Показывает частоты на оси y и значения переменных — на оси x; она дает визуальное представление о распределении данных.

```
sns.histplot(x = 'Признак1', hue = 'Признак2', data = df1, legend = False);
```

```
sns.histplot(x = 'Признак1', hue = 'Признак2', data = df, multiple = "fill", shrink = 0.8)
```

```
sns.set()
ax = sns.countplot(x = "Признак1", data = df)
ax = ax.set_xticklabels(ax.get_xticklabels(), rotation = 45)
```

```
df.plot.bar()
```

```
fig = px.bar(df1, x='Признак1', y='Признак2', color='Признак1', text_auto=True)
fig.show();
```

**➡️ Диаграмма рассеяния**

График, в котором ось x является значением одной переменной, а ось y — значением другой.

```
df.plot(kind='scatter', x='Признак1', y='Признак2', c=colors)
```

```
plt.scatter (x, y, s = нет, c = нет, cmap = нет)
```

```
sns.scatterplot(x = "Признак1", y = "Признак2", data = df, color = 'hotpink')
```

```
sns.pairplot(df, hue = 'Признак1')
```

**➡️ Диаграмма размаха**

Верх и низ коробки находятся соответственно в 75-м и 25-м процентилях — также дает быстрое представление о распределении данных; она часто используется на парных графиках с целью сравнения распределений.

```
sns.boxplot(x="Признак1", y="Признак2", data=df)
```

```
df.boxplot(column=['Признак1'])
```

```
fig = px.box(df, x="Признак1", y="Признак2")
fig.show()
```

**➡️ График плотности**

Показывает распределение значений данных в виде сплошной линии.

```
df['Признак1'].plot(kind='density')
```

```
sns.distplot(df1)
```

**➡️ Круговые диаграммы**

Частота или доля каждой категории, отображаемая в виде сектора круга.

```
data_names = pd.Series(df.Признак1.unique())
plt.pie(df, autopct='%.1f', labels=data_names)
```

**➡️ Тепловая карта**

```
sns.heatmap(df, cmap="Reds", annot = True);
```

**➡️ Древовидная диаграмма**

```
fig = px.treemap(df2, path=['Признак1'], values='Признак2', color='Признак1')
fig.show()
```

### 🚩 Корреляция

**Анализ корреляций количественных признаков** 

При выявлении связи между количесвенными признаками выдвигается следующая нулевая гипотеза: 

$H_0:\rho=0$  (связи нет, коэффициент корреляции не является статистически значимым)

$H_1:\rho \ne0$ (связь есть, коэффцициент корреляции является статистически значимым)

```
numeric = ['Признак1', 'Признак2', 'Признак3']
df[numeric].corr('spearman') # pearson или spearman или kendall
sns.heatmap(df[numeric].corr('spearman'))
```

```
from scipy.stats import pearsonr, spearmanr, kendalltau
r = pearsonr(df['Признак1'], df['Признак2']) #pearsonr, spearmanr, kendalltau
print('Pearson correlation:', r[0], 'p-value:', r[1])
```

👀 ❗❗❗ Так как *p-value* < 0.05 (типичное пороговое значение), то делаем вывод о том, что взаимосвязь (корреляция) между *Признак1* и *Признак2* статистически значима. Отвергаем нулевую гипотезу

**Анализ корреляций категориальных признаков** 

При выявлении связи между качественными признаками выдвигается следующая нулевая гипотеза: 

$H_0:\text{признаки независимы (связи нет)}$.

$H_1:\text{признаки не являются независимыми (связь есть)}$.

Коэффициенты и выводы для категориальных данных строятся на основании *таблиц сопряжённости*.
Вычисляем коэффициент $\chi^2$ или *тест Фишера*.

Как происходит проверка такой нулевой гипотезы? Сравниваются частоты, полученные на основе имеющихся данных и ожидаемые частоты – частоты, которые имели бы место, если нулевая гипотеза была бы верна. Считаются разности между наблюдаемыми и ожидаемыми частотами, возводятся в квадрат, чтобы учесть отклонения в обе стороны, и нормируются. Далее определяется сумма этих нормированных квадратов разностей (она имеет распределение [хи-квадрат](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D1%81%D0%BF%D1%80%D0%B5%D0%B4%D0%B5%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5_%D1%85%D0%B8-%D0%BA%D0%B2%D0%B0%D0%B4%D1%80%D0%B0%D1%82) с числом степеней свободы равным 
$(nrows-1)(ncols-1)$
), и оценивается, является ли полученное значение типичным для такого распределения хи-квадрат в случае, если нулевая гипотеза верна. 

Посмотрим на ожидаемые частоты:

```
pd.crosstab(df['Признак1'], df['Признак2'])

from scipy.stats import chi2_contingency, fisher_exact
chi2_contingency(pd.crosstab(df['Признак1'], df['Признак2'])) # коэффициент $\chi^2$
fisher_exact(pd.crosstab(df['Признак1'], df['Признак2'])) # Фишер
```

👀 ❗❗❗ Малое значение *p-value* говорит о том, что связь статистически подтверждается. Отвергаем нулевую гипотезу



**Взаимосвязь категориального и числового признаков**

```
from scipy.stats import pointbiserialr
pointbiserialr(df['cardio'], df['weight']) #бисериальный коэффициент корреляции
```

## 🔮 Проверка гипотез о данных

```
s, pvalue = scipy.stats.ttest_ind(df1, df2, equal_var=True, alternative='two-sided')
print('p-значение равно {:5.3f}'.format(pvalue))
```
👀 ❗❗❗ Если **p-значение** велико - гораздо больше *уровня значимости* (0,05 или 0,01 или 0,005), следовательно **нет оснований отвергнуть нулевую гипотезу H0**

👀 ❗❗❗ Если **p-значение** ниже *уровня значимости* (0,05 или 0,01 или 0,005), то *отвераем нулевую гипотезу H0*.

📲 **Онлаин калькулятор** [A/B-Test Calculator] (https://abtestguide.com/calc/)

* Проверка гипотезы о нормальности распределения.<br>
H0: $X \sim N(\cdot, \cdot)$<br>
H1: $X \nsim N(\cdot, \cdot)$<br>
Критерий Шапиро-Уилка [scipy.stats.shapiro](https://docs.scipy.org/doc/scipy-0.14.0/reference/generated/scipy.stats.shapiro.html).<br>


* Критерий согласия Стьюдента.<br>
H0: $\mu = M$<br>
H1: $\mu \ne M$<br>
[scipy.stats.ttest_1samp](https://docs.scipy.org/doc/scipy-0.14.0/reference/generated/scipy.stats.ttest_1samp.html).<br>


* Проверка гипотезы о равенстве средних значений.<br>
H0: $\mu_1 = \mu_2$<br>
H1: $\mu_1 \ne \mu_2$<br>
Распределение выборок должно быть близко к нормальному.<br>
  * Для несвязных выборок: [scipy.stats.ttest_ind](https://docs.scipy.org/doc/scipy-0.14.0/reference/generated/scipy.stats.ttest_ind.html).<br>
  * Для связных выборок: [scipy.stats.ttest_rel](https://docs.scipy.org/doc/scipy-0.14.0/reference/generated/scipy.stats.ttest_rel.html).<br>
  

* Проверка гипотезы о равенстве медиан.<br>
  * Для несвязных выборок: критерий Манна-Уитни [scipy.stats.mannwhitneyu](https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.mannwhitneyu.html).<br>
  * Для связных выборок: критерий Уилкоксона [scipy.stats.wilcoxon](https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.wilcoxon.html).<br>
  * Критерий Муда [scipy.stats.median_test](https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.median_test.html).<br>


* Проверка гипотезы о равенстве дисперсий.<br>
H0: $\sigma_1 = \sigma_2$<br>
H1: $\sigma_1 \neq \sigma_2$<br>
Критерий Флингера-Килина [scipy.stats.fligner](https://docs.scipy.org/doc/scipy-0.17.0/reference/generated/scipy.stats.fligner.html).<br>


* Проверка гипотезы о равенстве долей категориального признака.<br>
H0: $p_1 = p_2$<br>
H1: $p_1 \ne p_2$<br>
Критерий хи-квадрат [scipy.stats.chi2_contingency](https://docs.scipy.org/doc/scipy-0.17.0/reference/generated/scipy.stats.chi2_contingency.html).<br>


* Проверка гипотезы о независимости (корреляция).<br>
H0: X и Y независимы<br>
H1: X и Y зависимы<br>
  * Для непрерыных величин: корреляция Пирсона [scipy.stats.pearsonr](https://docs.scipy.org/doc/scipy-0.14.0/reference/generated/scipy.stats.pearsonr.html),<br>
  * Для дискретных величин: корреляция Спирмэна [scipy.stats.kendalltau](https://docs.scipy.org/doc/scipy-0.14.0/reference/generated/scipy.stats.kendalltau.html).<br>

## 🚚 Машинное обучение
### ✨ Кластеризация

**Метод локтя**
```
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans

Sum_of_squared_distances = []
K = range(1, 20)
for k in K:
    km = KMeans(n_clusters = k)
    km = km.fit(df[["Признак 1", "Признак 2"]])
    Sum_of_squared_distances.append(km.inertia_)
    
plt.plot(K, Sum_of_squared_distances, 'bx-')
plt.xlabel('k')
plt.ylabel('Сумма кв. откл')
plt.title('Метод локтя')
plt.show()
```
**Модель кластеризации**
```
kmeans = KMeans(n_clusters = 5, random_state=0).fit(df[["Признак 1", "Признак 2"]])
predict = kmeans.predict(df[["Признак 1", "Признак 2"]])
df['Кластер'] = predict
df.head()
```

**Визуализация результата**
```
plt.scatter(df['Признак 1'], df["Признак 2"], c = kmeans.labels_, cmap='viridis', alpha = 0.6)
plt.title('5 кластеров K-Means')
```


## 🛒 Рекомендательные системы (коллаборативная фильтрация по схожести пользователей)

**Переименовать признаки**
```
df.columns = ['user','item','rating']
```

### Вариант 1. kNN sklearn.neighbors
```
from sklearn.neighbors import NearestNeighbors  
from collections import defaultdict
from scipy.sparse import csr_matrix 

df_matrix = df.pivot(index= 'user',columns='item',values='rating').fillna(0)
w1_pivot_matrix = csr_matrix(df_matrix)


knn = NearestNeighbors(n_neighbors=10, algorithm= 'brute', metric= 'cosine')
model_knn = knn.fit(w1_pivot_matrix)

def most_similar_users_to(user_id):
    most_similar_users_to = []
    distance, indice = model_knn.kneighbors(df_matrix.iloc[user_id,:].values.reshape(1,-1), n_neighbors=10)
    for i in range(1, len(distance.flatten())):
        user_id1 = df_matrix.index[indice.flatten()[i]]
        most_similar_users_to.append((user_id1, distance.flatten()[i]))

    most_similar_users_to.sort(key=lambda x: x[1], reverse=True)

    return most_similar_users_to[:10] 
    
    
def user_based_suggestions(user_id):
    # суммировать все коэффициенты подобия
    suggestions = defaultdict(float)
    non_interacted_items = df_matrix.iloc[user_id][df_matrix.iloc[user_id]==0].index.tolist()
    for other_user_id, similarity in most_similar_users_to(user_id):
        items_user_id = df_matrix.loc[other_user_id][df_matrix.loc[other_user_id]>0]
        for interest in items_user_id.index.tolist():
            if interest in non_interacted_items:
                 # для вывода списка товаров/фильмов,  df_items - датафрейм с названиями товаров/фильмов
                item_name = df_item[df_item['article_id']==interest]['product_name'].values[0]
                suggestions[item_name] += similarity
    # преобразовать их в сортированный список
    suggestions = sorted(suggestions.items(),
                         key=lambda x: x[1],
                         reverse=True)
    return suggestions[:10]    
    

print("Рекомендации для пользователя")
print(user_based_suggestions(Номер пользователя))
```

### Вариант 2. kNN surprise.prediction_algorithms.knns

```
# установка в терминале: conda install -c conda-forge scikit-surprise
from surprise import Dataset, Reader
from surprise.prediction_algorithms.matrix_factorization import SVD
from surprise import accuracy
from surprise.prediction_algorithms.knns import KNNBasic

reader = Reader(line_format='user item rating', sep=',', rating_scale=(0,5), skip_lines=1)
data = Dataset.load_from_df(df, reader=reader)
trainset = data.build_full_trainset()

# Параметры сходства
sim_options = {'name': 'cosine',
               'user_based': True}
sim_user = KNNBasic(sim_options=sim_options, verbose=False, random_state=33)
sim_user.fit(trainset)

def get_recommendations(user_id):
    recommendations = []
    user_interactions_matrix = df.pivot(index='user', columns='item', values='rating')
    non_interacted_items = user_interactions_matrix.loc[user_id][user_interactions_matrix.loc[user_id].isnull()].index.tolist()
    for item_id in non_interacted_items:
        est = sim_user.predict(user_id, item_id).est
        # для вывода списка товаров/фильмов,  df_items - датафрейм с названиями товаров/фильмов
        item_name = df_item[df_item['article_id']==item_id]['product_name'].values[0]
        recommendations.append((item_name, est))
    recommendations.sort(key=lambda x: x[1], reverse=True)
    return recommendations[:10] 
    
    
get_recommendations(Номер пользователя)    

```
