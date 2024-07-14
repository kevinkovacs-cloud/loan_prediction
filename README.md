# Preprocesamiento + Modelado/Evaluación/Predicción para otorgamiento de prestamos en R.
Clase: Fundamentos de datos.

Problema: 
Los datos de la base hipoteca.xls contiene datos de 2380 individuos que solicitaron una hipoteca.
La variable que nos interesa modelar es “deny”, un indicador de si la solicitud de hipoteca del solicitante ha sido aceptada (deny = 0) o denegada (deny = 1).
Los datos registrados dan información acerca de las siguientes variables:
pirat: Relación entre gastos e ingresos del individuo.
hirat: Relación entre gastos e ingresos de la vivienda.
lvrat: Relación préstamo/valor valor del bien a hipotecar.
Unemp: Tasa de desempleo en la industria de los solicitantes.
mhist: puntaje de crédito hipotecario de 1 a 4 (un valor bajo es un buen puntaje)
Phist: Indicador: ¿Mal historial de crédito público?
Insurance: Indicador: ¿Se le negó el seguro al individuo?
Single: Indicador: ¿El individuo es soltero?
Selfemp: Indicador: ¿Es el individuo un trabajador autónomo?

1.	Analice las variables disponibles para incluirlas de modo adecuado.
2.	Se quiere ajustar modelos de regresión logística que permita explicar y predecir el otorgamiento de hipoteca a partir de la información disponible. Para esto, antes que nada, separar los datos en conjuntos de entrenamiento y validación en forma aleatoria en 70/30. Indique que cantidad de casos quedaron para cada ambiente.
3.	Considere varios modelos posibles y compárelos adecuadamente en el conjunto de entrenamiento:
-	Un modelo con todas las variables disponibles 
-	Un modelo con todas las variables que resultaron significativas al 5%
-	Un modelo seleccionando con un método por pasos.

4.	Para el modelo elegido en el punto anterior: 
a)	¿Es significativo el modelo?
b)	¿Son todas las variables significativas para el modelo? 
c)	Considere un test de bondad de ajuste: ¿qué conclusión se obtiene?
d)	Elija uno de los coeficientes del modelo elegido e interprételo en términos de los odds.
e)	Indique valores de pseudos R2 
f)	Indique AUC y grafique la curva ROC en el conjunto de test.
g)	Encuentre la tabla de clasificación con un punto de corte de 0.5. ¿cuál es el porcentaje de casos bien clasificados? 
h)	¿Puede mejorar la clasificación variando el punto de corte? Proponga un punto de corte.
i)	Según el punto de corte dado en el ítem anterior, ¿cómo fue clasificado el caso Nº 100? ¿Fue clasificado correctamente? ¿Con qué probabilidad fue clasificado?
5.	Ajuste una red Naive.
6.	Ajuste un modelo svm.
7.	Finalmente, evalúe los modelos considerados en los puntos 4,5 y 6. ¿Cuál es el que predice mejor la clase positiva?
