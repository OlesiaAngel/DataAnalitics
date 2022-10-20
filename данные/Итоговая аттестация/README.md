# Материалы для итоговой аттестации

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

### ❗❗❗ Важность признаков

```
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import chi2

X = df
y = df.iloc[:, -1]

bestfeatures = SelectKBest(score_func = chi2, k = 'all')
fit = bestfeatures.fit(X, y)
dfscores = pd.DataFrame(fit.scores_)
dfcolumns = pd.DataFrame(X.columns)

featureScores = pd.concat([dfcolumns, dfscores], axis = 1)
featureScores.columns = ['Specs', 'Score']  
print(featureScores.nlargest(10, 'Score'))  
```

## 🛒 Рекомендательные системы

## 📈 EDA анализ 
### 🗑 Очистка данных

**Проверить типы данных**
```
df.info()

# пример преобразования типов данных
data["Дата"] = pd.to_datetime(data["Дата"])
data['Количество'] = data['Количество'].astype(int)
# создаем новый столбец
data['Дата2'] = data['Дата'].dt.date
```

**Проверить на пустые значения**
```
df.isnull().sum()
```

**Поиск и удаление дубликатов**
```
df.duplicated().sum()
df = df.drop_duplicates()
df.shape
```
**Поиск аномалий**
```
df.describe()

print('\033[1m'+ 'Уникальные значения'+'\033[0m'+'\n')
for i in df.columns.to_list():
    print('\033[91m'+ 'Признак {} имеет {} следующих уникальных значений:'.format(i, len(df[i].unique()))+'\033[0m')
    print(df[i].unique())
    print('\033[1m' + '---------------------------------------------------------------------------------'+ '\033[0m') 
```
### 📊 Визуализация
**sweetviz**
```
  !pip install sweetviz 

  import sweetviz as sv 

  my_report = sv.analyze(df) 
  my_report.show_html()
```
### 🔮 Проверка гипотез о данных
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
