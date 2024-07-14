# EJERCICIO de CLASIFICACION 
#  autor: SP
# fecha: 2024/07/11

rm(list=ls())
gc()

library(ggplot2)
library(dplyr)
library(readxl)
library(gridExtra)
library(kableExtra)
#library(knitr)

datos<- read_excel("hipoteca.xlsx")
View(datos)
datos<- datos[, -1] #sacamos la columna ID, nunca se incluye para modelado

sum(is.na(datos)) #no hay faltantes, dice rm = false
summary(datos)
str(datos)
#1.	Analice las variables disponibles para incluirlas de modo adecuado.
## Variable de respuesta como factor, sino nos tira hasta el promedio y está mal, es dummy
datos$deny <- as.factor(datos$deny)

# Analisis basico de cada variable continua respecto a deny.
bp1 <- ggplot(data = datos, aes(y = pirat), colour = factor(deny)) +
  geom_boxplot(aes(x = deny, fill = factor(deny))) +
  xlab("Deny") + ylab("Gastos / Ingresos (Individuo)") +
  theme(axis.text.x = element_blank(), axis.ticks = element_blank(),
        axis.line = element_line(colour = "royalblue", size = 0.5, linetype = "solid")) +
  labs(fill = "Deny") + scale_fill_brewer(palette="BuPu")

bp2 <- ggplot(data = datos, aes(y = hirat), colour = factor(deny)) +
  geom_boxplot(aes(x = deny, fill = factor(deny))) +
  xlab("Deny") + ylab("Gastos / Ingresos (Vivienda)") +
  theme(axis.text.x = element_blank(), axis.ticks = element_blank(),
        axis.line = element_line(colour = "royalblue", size = 0.5, linetype = "solid")) +
  labs(fill = "Deny") + scale_fill_brewer(palette="BuPu")

bp3 <- ggplot(data = datos, aes(y = lvrat), colour = factor(deny)) +
  geom_boxplot(aes(x = deny, fill = factor(deny))) +
  xlab("Deny") + ylab("Prestamo / Valor del bien") +
  theme(axis.text.x = element_blank(), axis.ticks = element_blank(),
        axis.line = element_line(colour = "royalblue", size = 0.5, linetype = "solid")) +
  labs(fill = "Deny") + scale_fill_brewer(palette="BuPu")

bp4 <- ggplot(data = datos, aes(y = unemp), colour = factor(deny)) +
  geom_boxplot(aes(x = deny, fill = factor(deny))) +
  xlab("Deny") + ylab("Tasa de desempleo en su rubro") +
  theme(axis.text.x = element_blank(), axis.ticks = element_blank(),
        axis.line = element_line(colour = "royalblue", size = 0.5, linetype = "solid")) +
  labs(fill = "Deny") + scale_fill_brewer(palette="BuPu")

grid.arrange(bp1, bp2, bp3, bp4)
# Se detecta una observacion atipica pirat y hirat 
which(datos$pirat == max(datos$pirat))
datos[1095, ] #veo que es atipica en ambas, no tiene sentido que gasto 3 veces más que ingreso
datos <- datos[-1095, ] #quito ese caso
#analizo multicolinealidad
library(corrplot)
cuantis<-datos[,c('pirat','hirat','lvrat','unemp')]
correlaciones<-cor(cuantis)
corrplot(correlaciones, method="number",tl.col="black",tl.cex=0.8)
#no se ven problemas graves.. muy poca correlacion, casi no se ven los numeros 

#para ver como entrar cada variable al modelo:
datos$mhist <- factor(datos$mhist) 
datos$phist <- factor(datos$phist) 
datos$insurance <- factor(datos$insurance)
datos$selfemp <- factor(datos$selfemp)
datos$single <- factor(datos$single)

#ver si no hay casillas con pocos datos, tabla es para ver en una tabla
#la vertical es deny y la horizontal las otras variables factor
table(datos$deny,datos$mhist) #podria recategorizarse juntando 3 y 4, son los menos
table(datos$deny,datos$phist) #son 2 y 2, está bien
table(datos$deny,datos$insurance) #casi todos los valores son "no", 2091
table(datos$deny,datos$single)
table(datos$deny,datos$selfemp)

#"mhist" tiene una casilla con 5 valores (categoría 4) y otra de 9 valores (categoría 3) cuando deny=1. Como el resto de las categorías, divididas por "deny", tienen muchos más valores se adopta como criterio unificar los niveles 3 y 4.
## Transformo categoría 4 de mhist en 3
datos$mhist <- ifelse(datos$mhist == 4, 3, datos$mhist)
datos$mhist <- factor(datos$mhist) 
# Visualizo cantidad de nuevas categorías
table(datos$deny,datos$mhist)


#2.	separo train/test
set.seed(666)
indice <- sample(1:nrow(datos),nrow(datos)*0.70,replace=FALSE)
train <- datos[ indice,]
test  <- datos[-indice,]

#3. Ajustar modelos de regresión logística
#modelo1: todas, el puntito significa todo el resto
mod1 <- glm(deny ~ ., data = train,
               family = binomial)
summary(mod1)
#modelo2: con significativas
mod2<-glm(deny ~ pirat + lvrat + mhist + phist + insurance + single,data=train,family = binomial)
summary(mod2)
#modelo3: con step
mod3<-step(mod1, direction = "backward", trace = 1)
summary(mod3)

#comparo los 3 modelos segun AIC buscando el menor akaike:
akaike<-AIC(mod1,mod2,mod3)

#4.#elijo modelo 3 porque tiene menor AIC
options(digits=10) #para evitar notacion cientifica
summary(mod3)
# a)	¿Es significativo el modelo?
modeloNULL<- glm(deny ~ 1, family = "binomial", data =train) #solo el intercepto
anova(mod3,modeloNULL,test = "Chisq") #da pvalor chico, entonces es significativo el modelo.
#está comparando el modelo con variables VS un modelo (casi) totalmente vacío
summary(modeloNULL)

#b)¿Son todas las variables significativas para el modelo?
#selfemp poco!! tampoco lo es mhist3, el resto tiene pvalues chiquitos

# c)	Considere un test de bondad de ajuste: ¿qué conclusión se obtiene?
library(generalhoslem)
logitgof(train$deny, fitted(mod3))
#pvalor=0.549 entonces no hay evidencia para rechazar H0: el ajuste es bueno
#no hay evidencia para decir que el ajuste es malo

#d)	Elijo uno de los coeficientes del modelo 3:
# beta(insuranceyes)= 4.63
#exp(4.63)=102.514 entonces la chance .....

#e)	Indique valores de pseudos R2, no podemos hacer mas nada q verlos
library(DescTools)
PseudoR2(mod3, c("CoxSnell", "Nagel"))
#f) Indique AUC y grafique la curva ROC en el conjunto de test.
#CURVA ROC Y AUC
library(ROCR)
proba <- predict.glm(mod3, newdata = test, type = "response") #da probabilidades
predi <- prediction(proba, test$deny)
roc_mod3 <- performance(predi, measure = "tpr", x.measure = "fpr")
plot(roc_mod3, main = "curva ROC modelo logistico", colorize = T)
abline(a = 0, b = 1)
AUC_mod3 <- performance(predi, "auc")
#para que me de AUC:
AUC_mod3@y.values #area bajo ROC = 0.727885 da la "capacidad predictiva" del modelo.

#g)	Encuentre la tabla de clasificación con un punto de corte de 0.5. 
predi.y <- ifelse(proba >= 0.5, 1, 0)
comparar <- data.frame("real" = test$deny, "predicho" = predi.y)
kable(head(comparar, 10), caption = "Datos a comparar previo a matriz de confusión" )
matriz_confusion <- table(predi.y,test$deny, dnn = c( "predicho","observado"))### OJO!!! 
# para usar lo que sigue necesito que la matriz esté en la forma table("predicho","real)
library(caret)
confusionMatrix(matriz_confusion,positive = "1")

#h)	¿Puede mejorar la clasificación variando el punto de corte? 
# mejorar punto de corte evaluando accuracy
pc <- seq(from = 0.1, to = 0.9, by = 0.1)
accu<-rep(0,length(pc))
for(i in 1:length(pc))
{ predi.mod<-ifelse(proba >=i/10 , "1", "0")  
confusion <- table(test$deny, predi.mod)
MC<-confusionMatrix(confusion,positive = "1")
accu[i]<-MC$overall[1]
}
max(accu)
plot(pc,accu)
#según eso el punto de corte que maximiza accuracy está alrededor de 0.5

#i) ¿cómo fue clasificado el caso Nº 100? con punto de corte=0.5
dato.100 <- datos[100, ]
predi.100.prob <- predict.glm(mod3, newdata = dato.100, type = "response")[[1]]
predi.100.clase <- ifelse(predi.100.prob >= 0.5, 1, 0)

dato.100$deny # Clase real
predi.100.clase # Clase predicha
predi.100.prob # Probabilidad predicha

#5.	Ajuste una red NAIVE BAYES
library(e1071)
modNB<-naiveBayes(deny~.,data=train)
summary(modNB)
pr.NB<-predict(modNB,test,type="class")
conf_NB<-table(pr.NB,test$deny)
library(caret)
confusionMatrix(conf_NB,positive = "1")

library(ROCR)
proba.NB<-predict(modNB,test,type="raw")[,2] #esto da las probabilidades de deny=1
plot(proba.NB~test$deny) #no parece discriminar mucho...
prediNB <- prediction(proba.NB, test$deny)
roc_modNB <- performance(prediNB, measure = "tpr", x.measure = "fpr")
plot(roc_modNB, main = "curva ROC Naive", colorize = T)
abline(a = 0, b = 1)
AUC_modNB <- performance(prediNB, "auc")
#para que me de AUC:
AUC_modNB@y.values #area bajo ROC = 0.770783

#6.	Ajuste un modelo svm.
#mejorando SVM: introduzco un costo de violación de restricciones. Cost=1 y class.weights =1 es el default
svm_cv <- tune("svm", deny~., data = train,
               kernel = 'radial',
               ranges = list(cost = c(0.001, 0.01, 0.1, 1, 5, 10, 20, 50, 100)),
               , probability = TRUE)
summary(svm_cv)
names(svm_cv)
svm_cv$performances 
#veamos relacion entre errores y Costo:
ggplot(data = svm_cv$performances, aes(x = cost, y = error)) +
  geom_line() +
  geom_point() +
  labs(title = "Error de clasificación vs hiperparámetro C") +
  theme_bw()

svm_mejor <- svm_cv$best.model
confusion.svm_mejor<-table(predict(svm_mejor , test[,-10]),test$deny,dnn=list('predicho','real'))
confusionMatrix(confusion.svm_mejor,positive = "1")

proba.SVM <- predict(svm_mejor, newdata = test, probability = TRUE)
proba.SVM <- attr(proba.SVM, "probabilities")[,2]  # Probabilidades para la clase positiva
plot(proba.SVM ~ test$deny, main = "Probabilidades SVM vs Clase Real")
prediSVM <- prediction(proba.SVM, test$deny)
roc_modSVM <- performance(prediSVM, measure = "tpr", x.measure = "fpr")
plot(roc_modSVM, main = "Curva ROC SVM", colorize = T)
abline(a = 0, b = 1)
AUC_modSVM <- performance(prediSVM, "auc")
#para que me de AUC:
AUC_modSVM@y.values #area bajo ROC =0.719119

#7.	Finalmente, evalúe los modelos considerados en los puntos 4,5 y 6. 





