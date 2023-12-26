import streamlit as st
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix, accuracy_score, roc_curve, auc
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import label_binarize
from itertools import cycle
from catboost import CatBoostClassifier
import joblib
import os

# Функция для загрузки данных
@st.cache
def load_data(filepath):
    data = pd.read_csv(filepath)
    return data

# Функция для подготовки данных
def prepare_data(df):
    feature_lst = ['EVENT_TIME', 'ADDR_PCT_CD', 'month', 'day', 'Latitude',
                   'Longitude', 'BORO_NM', 'IN_PARK', 'IN_PUBLIC_HOUSING', 
                   'IN_STATION', 'VIC_AGE_GROUP', 'VIC_RACE', 'VIC_SEX', 
                   'LAW_CAT_CD']
    df_sel = df[feature_lst].copy()
    df_sel = pd.get_dummies(df_sel)
    return df_sel

# Функция для обучения модели
def train_model(X_train, y_train, X_test, y_test):
    model = CatBoostClassifier(l2_leaf_reg=10, max_depth=10, n_estimators=100,
                               loss_function='MultiClass', use_best_model=True,
                               random_seed=42)
    model.fit(X_train, y_train, eval_set=(X_test, y_test), verbose=False)
    return model

# Функция для отображения матрицы путаницы
def plot_confusion_matrix(y_test, y_pred):
    cm = confusion_matrix(y_test, y_pred)
    fig, ax = plt.subplots()
    sns.heatmap(cm, annot=True, fmt="d", ax=ax)
    plt.ylabel('Фактические значения')
    plt.xlabel('Предсказанные значения')
    st.pyplot(fig)

# Функция для отображения ROC-кривой для многоклассовой классификации
def plot_multiclass_roc_curve(y_test, y_score, n_classes):
    # Бинаризация y_test для многоклассовой классификации
    y_test_bin = label_binarize(y_test, classes=range(n_classes))

    # Вычисление ROC-кривой и ROC-AUC для каждого класса
    fpr = dict()
    tpr = dict()
    roc_auc = dict()
    for i in range(n_classes):
        fpr[i], tpr[i], _ = roc_curve(y_test_bin[:, i], y_score[:, i])
        roc_auc[i] = auc(fpr[i], tpr[i])

    # Построение всех ROC-кривых
    fig, ax = plt.subplots()
    colors = cycle(['blue', 'red', 'green', 'yellow', 'cyan', 'magenta', 'black'])
    for i, color in zip(range(n_classes), colors):
        ax.plot(fpr[i], tpr[i], color=color, lw=2,
                label='ROC curve of class {0} (area = {1:0.2f})'
                ''.format(i, roc_auc[i]))

    ax.plot([0, 1], [0, 1], 'k--', lw=2)
    ax.set_xlim([0.0, 1.0])
    ax.set_ylim([0.0, 1.05])
    ax.set_xlabel('False Positive Rate')
    ax.set_ylabel('True Positive Rate')
    ax.set_title('Some extension of Receiver operating characteristic to multi-class')
    ax.legend(loc="lower right")
    st.pyplot(fig)

# Заголовок приложения
st.title("Анализ преступлений в Нью-Йорке")
data_file = st.sidebar.file_uploader("Загрузите данные", type=["csv"])

if data_file is not None:
    data = load_data(data_file)
    df_prepared = prepare_data(data)
    target = 'LAW_CAT_CD'
    X = df_prepared.drop(target, axis=1)
    y = df_prepared[target]

    # Разделение данных на обучающую и тестовую выборки
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # Обучение модели
    if st.sidebar.button('Обучить модель'):
        with st.spinner('Модель обучается...'):
            model = train_model(X_train, y_train, X_test, y_test)
            y_pred = model.predict(X_test)
            y_pred_proba = model.predict_proba(X_test)
            accuracy = accuracy_score(y_test, y_pred)
            n_classes = len(y.unique())

            # Вывод результатов
            st.success('Обучение завершено!')
            st.write(f"Точность модели CatBoost: {accuracy:.4f}")
            plot_confusion_matrix(y_test, y_pred)
            plot_multiclass_roc_curve(y_test, y_pred_proba, n_classes)

            # Сохранение модели
            save_path = st.text_input('Введите путь для сохранения модели', 'catboost_crime_model.joblib')
            if st.button('Сохранить модель'):
                joblib.dump(model, save_path)
                st.write(f'Модель сохранена в {save_path}')

