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

**Преименовать признаки**
```
df.columns = ['user','item','rating']
```

### Вариант 1. kNN sklearn.neighbors
```
from sklearn.neighbors import NearestNeighbors  
from collections import defaultdict

df_matrix = data.pivot(index= 'user',columns='item',values='rating').fillna(0)
w1_pivot_matrix = csr_matrix(df_matrix)


knn = NearestNeighbors(n_neighbors=10, algorithm= 'brute', metric= 'cosine')
model_knn = knn.fit(w1_pivot_matrix)

def most_similar_users_to(user_id):
    most_similar_users_to = []
    distance, indice = model_knn.kneighbors(df_matrix.iloc[user_id,:].values.reshape(1,-1), n_neighbors=10)
    print('Рекомендации для ## {0} ##:'.format(df_matrix.index[user_id]))
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
                suggestions[interest] += similarity

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
        recommendations.append((item_id, est))
    recommendations.sort(key=lambda x: x[1], reverse=True)
    return recommendations[:10] 
    
    
get_recommendations(Номер пользователя)    

```


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
