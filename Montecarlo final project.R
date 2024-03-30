# 1. Monte Carlo Simulation Example 1 / Simulación de Montecarlo Ejemplo 1
# 2. Monte Carlo Simulation Example 2 / Simulación de Montecarlo Ejemplo 2
# 3. Sensitivity Analysis / Análisis de Sensibilidad


#----------------------------------------------------------
# Load Libraries & Functions / Carga de Librerías y funciones
source("https://pastebin.com/raw/K5rqVMCE")
#----------------------------------------------------------

#----------------------------------------------------------
# Task 1 - Transfer Function; Y = function(X1, X2, etc)
#          Triange made of 3 bars, AB, BC, CA 
#          See https://pasteboard.co/JMPvQPaY.png
#          Each bar is 100 units in length
#          Angle C is 60 degrees as designed
#          Mfg variation in bars +/- 1.0 
#          Calculate Angle Distribution
#          
#----------------------------------------------------------
#
# Tarea 1 - Función de transferencia; Y = function(X1, X2, etc)
#          Triángulo hecho de 3 barras, AB, BC, CA 
#          Cada barra tiene 100 unidades de longitud
#          El ángulo C tiene 60 grados como fue diseñado
#          La variación en las barras es  +/- 1.0 
#          Calcular la distribución del ángulo
#          
#----------------------------------------------------------

# Normal Way - Calculating Avg / Forma regular - Calculo de promedio

#Assigning random values / Asignamos valores aleatorios

AB = 99.8; BC = 100.12; CA = 99.94

AngleC = acos( (BC^2 + CA^2 - AB^2) / (2*BC*CA) )  # cosine law / ley de cosenos
AngleC = AngleC * 180/pi                           # radians to degrees / radianes a grados

cat("\n", "AngleC :", AngleC, "\n")

# Simulating Distribution of Angle-C
# First we generate random samples of bars, normally distributed. / Generamos muestras aleatorias de barras distribuidas normalmente.

AB = rnorm(1000, 100, 1/3)   # 99.73 % fall within 3 std devs / 99.73% estaran dentro de 3 std devs
BC = rnorm(1000, 100, 1/3)
CA = rnorm(1000, 100, 1/3)

#We store the result of the calculation in the variable AngleC / Almacenamos el resultado del calculo en la variable AngleC

AngleC = acos( (BC^2 + CA^2 - AB^2) / (2*BC*CA) )   # cosine law

AngleC = AngleC * 180/pi                            # radians to degrees

#We take the first 500 elements of the AngleC variable, calculate mean and sd. / Tomamos los primeros 500 elementos de la variable AngleC calculamos media y sd

AngleC[1:500]; mean(AngleC); sd(AngleC)

#Histogram / Histograma

hist(AngleC)

#----------------------------------------------------------
# Task 4 - Transfer Function; Y = function(X1, X2, etc)
#          Florist Business 
#          Small, Medium, Large (Profit: $5, $7, $10)
#          Avg. Orders (20,15,10)
#          Cake Orders (Profit: $10) - 5% orders
#          Chocolates  (Profit: $3)  - 10% orders
#          If > 50 bouquets are in a day
#               handling costs 10% of the profit
#          Calculate Annual Profit Distribution
#----------------------------------------------------------
# Task 4 - Función de transferencia; Y = function(X1, X2, etc)
#          Negocio de Flores 
#          Pequeño, Medio, Grande (Utilidad: $5, $7, $10)
#          Promedio de órdenes (20,15,10)
#          Órdenes de pasteles (Utilidad: $10) - 5% órdenes
#          Chocolates  (Utilidad: $3)  - 10% órdenes
#          Si > 50 bouquets son en un día
#               costos de manipulación son 10% de la utilidad
#          Calcular la distribución de ganancias anuales.
#----------------------------------------------------------

VS = 20; VM = 15; VL = 10   #promedio de órdenes  
PS = 5;  PM = 7;  PL = 10   #utilidad por tipo de orden
XCake = 0.05; XChoc = 0.10  #porcentaje de órdenes de pastel y chocolates
PCake =  10;  PChoc = 3; Max = 50 #utilidad por pastel y chocolates, numero de ordenes maximas 50

VCake = XCake * (VS+VM+VL) #volumen de ordenes de pastel
VChoc = XChoc * (VS+VM+VL)    #volumen de ordenes de chocolates

# Step 1 - Using R Function As A Transfer Function 
# Paso 1 - Usar R Function como una función de transferencia

GetProfit <- function(VS,VM,VL, PS,PM,PL, VCake,VChoc, PCake,PChoc, Max) {
  Profit = VS*PS + VM*PM + VL*PL + 
    VCake*PCake + VChoc*PChoc
  if(VS+VM+VL > Max) Profit = 0.9 * Profit
  return(Profit)
}

GetProfit(VS,VM,VL, PS,PM,PL, VCake,VChoc, PCake,PChoc, Max)

GetProfit(VS+5,VM,VL, PS,PM,PL, VCake,VChoc, PCake,PChoc+3, Max)

xV
# Paso 2 - Generar Xs simulados de vectores de distribuciones estadísticas
#          con prefijo "x"

nsim = 365                # Days in the Year / Días del año
#generamos valores aleatorios utilizando la distribucion de poisson
xVS = rpois(nsim, VS)     # Daily Qty of Small Boquets / Cantidad diaria de pequeños
xVM = rpois(nsim, VM)     # Daily Qty of Medium Boquets / Cantidad diaria de medios
xVL = rpois(nsim, VL)     # Daily Qty of Large Boquets / Cantidad diaria de grandes

xVCake = rbinom(nsim, VS+VM+VL, XCake) # Daily Qty of Cake Orders/ Cantidad diara de ordenes de pastel
xVChoc = rbinom(nsim, VS+VM+VL, XChoc) # Daily Qty of Choc Orders / Ctd diaria de ordenes de choc

#generamos una tabla (dataFrame) con los valores aleatorios

Xtable = data.frame(Qty_Small    = xVS, 
                    Qty_Medium   = xVM,
                    Qty_Large    = xVL,
                    Price_Small  = 5, 
                    Price_Medium = 7,
                    Price_Large  = 10,
                    Qty_Cake     = xVCake,
                    Qty_Choc     = xVChoc,
                    Price_Cake   = 10,
                    Price_Choc   = 3,
                    Qty_Penalty  = 50)

head(Xtable)
# Step 3 - Generate Simulated Y & Analyse
#          Apply Function To Simulated Xs
#Paso 3 - Generar Y simulados y analizar
#         Aplicar la funcion a los X simulados

Profit = SimulateY(GetProfit, Xtable) #usamos la funcion de getprofit y la tabla X
hist(Profit)

cat("\n", "Avg Daily Profit    :", mean(Profit), "\n",
    "Total Annual Profit :", sum(Profit), "\n","\n")

# What is the chance the Florist makes atleast $300/day
# Probabilidad de que el florista gane al menos $300/día

length(Profit)
length(Profit[Profit >= 300]) / length(Profit)

# Export Data Into A Spreadsheet
cbind(Xtable,Profit)[1:5,]
write.csv(cbind(Xtable,Profit), "out.csv")

# Exercise - Plot Change In Profit Histogram
#      if the price of Small Boquets (PS)
#      is increased by 1% 
# Ejercicio, cambio en el histograma de utilidades
#     si el precio de pequeños bouquets(PS)
#     se incrementa por 1%

Xtable1 = Xtable;
Xtable1$Price_Small = Xtable$Price_Small * 1.01

Profit0 = SimulateY(GetProfit, Xtable)
Profit1 = SimulateY(GetProfit, Xtable1)


hist(Profit1 - Profit0)
100*mean(Profit1 - Profit0)/mean(Profit0)
#----------------------------------------------------------
# Task 5 - Sensitivity Analysis
#          When Xs are changed by 1%
#          Find % change in Y 
#          Find the most sensitive Xs 
#----------------------------------------------------------
# Tarea 5 - Análisis de sensibilidad 
#         cuando Xs cambian 1%
#         Encontrar el porcentaje de cambio en Y
#         Encontrar las Xs más sensibles
#
# METHOD A - Sensitivity of Transfer Function
#            Determined at a given X values
# Método A - Sensibilidad de la función de transferencia
#            Determinado por valores dados de X
#
# Step1  - Define the Transfer Function
# Paso 1 - Definir la función de transferencia


GetProfit <- function(VS,VM,VL, PS,PM,PL, VCake,VChoc, PCake,PChoc, Max) {
  Profit = VS*PS + VM*PM + VL*PL + 
    VCake*PCake + VChoc*PChoc
  if(VS+VM+VL > Max) Profit = 0.9 * Profit
  return(Profit)
}

# Step 2 - Define a List of Variables with Values
# Paso 2 - Definir una lista de variables con valores

Xvals = list(QtySmall = 20, 
             QtyMedium   = 15,
             QtyLarge    = 10,
             PriceSmall  = 5, 
             PriceMedium = 7,
             PriceLarge  = 10,
             QtyCake     = 0.05*(20+15+10),
             QtyChoc     = 0.10*(20+15+10),
             PriceCake   = 10,
             PriceChoc   = 3,
             QtyPentalty = 50)

# Step 3 - Run the Sensitivity Analysis Function
#          Calculated At The Current X values
# Paso 3 - Correr el análisis de sensibilidad 
#           Calculado en los valores X actuales

S = MonteCarloSens(GetProfit, Xvals)
print(S)






