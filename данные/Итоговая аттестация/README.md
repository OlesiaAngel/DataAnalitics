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
