from sklearn.model_selection import train_test_split
import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder
from sklearn.pipeline import Pipeline
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import classification_report, confusion_matrix
import joblib

datos = pd.read_csv("dataset_diagnostico.csv")

CATEGORICAS = ["encendido", "estado_pantalla", "respuesta_tactil", "estado_carga", "reinicios_frecuentes","golpe_reciente"]
OBJETIVO = "diagnostico_original"

x = datos[CATEGORICAS]
y = datos[OBJETIVO]

x_entreno, x_prueba, y_entreno, y_prueba = train_test_split(
    x, y, test_size=0.2, stratify=y, random_state=42
)

preparacion = ColumnTransformer([
    ("categoricas", OneHotEncoder(handle_unknown="ignore"), CATEGORICAS),
])

modelo = Pipeline([
    ("preparacion", preparacion),
    ("arbol", DecisionTreeClassifier(max_depth=8, min_samples_leaf=5, random_state=42)),
])

modelo.fit(x_entreno, y_entreno)

prediccion = modelo.predict(x_prueba)
print(f"Exactitud: {(prediccion == y_prueba).mean():.1%}")
print(classification_report(y_prueba, prediccion, digits=3))

etiquetas = sorted(y.unique())
print(pd.DataFrame(
    confusion_matrix(y_prueba, prediccion, labels=etiquetas),
    index=etiquetas, columns=etiquetas,
))

joblib.dump(modelo, "modelo_diagnostico.joblib")