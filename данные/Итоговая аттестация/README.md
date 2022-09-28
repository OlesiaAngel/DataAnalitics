# Материалы для итоговой аттестации

## 🚚 Машинное обучение

### ❗❗❗ Важность признаков

## 📑 Рекомендательные системы

## EDA анализ 

### 📊 Визуализация
**sweetviz**
```
  !pip install sweetviz 

  import sweetviz as sv 

  my_report = sv.analyze(df) 
  my_report.show_html()
```

**pandas-profiling**
```
pip install pandas-profiling
conda install -c conda-forge pandas-profiling

# импорт библиотек
import pandas as pd
import pandas_profiling

# загружаем датасет
df = pd.read_csv('adult.data.csv')

# создаём отчёт
profile = df.profile_report(title='Pandas Profiling Report', progress_bar=False)
# смотрим отчёт в HTML формате
profile
```
