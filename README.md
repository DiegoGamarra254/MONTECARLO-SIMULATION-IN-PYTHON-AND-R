# MONTE CARLO SIMULATION IN PYTHON AND R 
 ### *This is a basic example of the use of the Monte carlo Simulation in Python and R* 
 *by Diego Gamarra Rivera* 
 
 (Español abajo)

Monte Carlo simulation is a computational technique used to model the probability of different outcomes in a process that cannot easily be predicted due to the intervention of random variables. It's named after the famous Monte Carlo Casino in Monaco, known for its games of chance, as randomness plays a key role in the simulation.

The basic idea behind Monte Carlo simulation is to use random sampling methods to solve problems that might be deterministic in principle but are too complex to solve analytically. It involves running numerous simulations of a model with randomized inputs, and then analyzing the results to understand the range of possible outcomes and their probabilities.

Here's a simplified step-by-step process of how Monte Carlo simulation works:

**Define input parameters** : Identify the variables that affect the outcome of the system and define their probability distributions.

**Generate random inputs**: Randomly sample values from the defined probabilistic distributions for each input variable.

**Run simulations** : Use the sampled input values as inputs to the model and run the simulation. Repeat this process for a large number of iterations.

**Analyze results**: Collect the outputs from each simulation and analyze them to understand the range of possible outcomes and their probabilities. This might involve calculating summary statistics, constructing histograms, or generating probability density functions.

**Draw conclusions** : Based on the results of the simulations, draw conclusions about the behavior of the system and make decisions or recommendations accordingly.

Monte Carlo simulation is widely used in various fields such as finance, engineering, physics, and operations research to analyze systems and make informed decisions in the face of uncertainty. It's particularly valuable when dealing with complex systems with multiple interacting variables and uncertain parameters.

We will use the Monte Carlo simulation in 2 examples with Python and R 

## Example 1 

In this example we have a triangle made out of 3 bars, each bar is 100 units of length and the Manufacturing tolerance is +-1 unit, in this example we assume that the standard deviation is 1/3, with the only purpose of getting the 99.73% of the data to fall under the manufacturing tolerance. We need to provide the distribution and mean of one of the angles of the triangle considering that the bars will not be perfectly 100 units due to process variability.
In a real situation, the manufacturing tolerance would be provided by the client and the standard deviation would be the result of the calculation done over the process.
So, for this example we will simulate random values of bars in order to calculate simulated values of the angle, considering that they follow a normal distribution, we store those values in arrays and calculate the mean  and standard deviation of the angle
```
import numpy as np
import pandas as pd
AB=np.random.normal(100, 1/3, 1000)
AC=np.random.normal(100, 1/3, 1000)
CB=np.random.normal(100, 1/3, 1000)

# Applying the cosine law
AngleC = np.arccos((CB**2 + AC**2 - AB**2) / (2 * CB * AC))

# Converting radians to degrees
AngleC_deg = np.degrees(AngleC)

# Calculating mean and standard deviation
mean_angle = np.mean(AngleC_deg)
std_dev_angle = np.std(AngleC_deg)
print('Mean of angle C:', mean_angle)
print('Standard deviation of angle C:',std_dev_angle)

```

Additionally we wil generate a graphic showing the distribution of the angle and other statistics.

![Gauss](/Assets/1.png)

## Example 2
For the second example we will have a business that has 3 types of products (Small, Medium and Large) with daily average orders (20, 15 , 10) and profits ($5, $7, $10) additionally 2 products expressed as percentage of total orders: Cake Orders (Profit: $10) - 5% orders, Chocolates  (Profit: $3)  - 10% orders. Additionally we have a restriction: If the business sells more than 50 bouquets are in a day handling costs 10% of the profit. In this case we will need to simulate those variables in order to get the average profit in one year (365 days), the variables follow possion and binomial distribution

```
# Simulate values following poisson and binomial distribution. / Simulamos los valores siguiendo distribucions de Poisson y Binomial.
n=365
xVS = np.random.poisson(VS, n)
xVM = np.random.poisson(VM, n)
xVL = np.random.poisson(VL, n)
xVCake = np.random.binomial(VS+VL+VM, XCake, n)
xVChoc = np.random.binomial(VS+VL+VM, XChoc, n)

# Create a data frame containing the simulated values and the fixed values like 'Price_Small' to perform the calculations 
#/ Crear un data frame que contiene los valores simulados y valores fijos como 'Price_small'
df = pd.DataFrame({ 
    'Qty_Small': xVS,
    'Qty_Medium':xVM,
    'Qty_Large':xVL,
    'Price_Small':5,
    'Price_Medium':7,
    'Price_Large':10,
    'Qty_Cake': xVCake,
    'Qty_Choc': xVChoc,
    'Price_Cake':10,
    'Price_Choc':3,
    'Qty_penalty':50

#Create the function to calculate the profit / Crear la funcion para calcular la utilidad
def getprofit1(row):
    VS = row['Qty_Small']
    VM = row['Qty_Medium']
    VL = row['Qty_Large']
    PS = row['Price_Small']
    PM = row['Price_Medium']
    PL = row['Price_Large']
    VCake = row['Qty_Cake']
    VChoc = row['Qty_Choc']
    PCake = row['Price_Cake']
    PChoc = row['Price_Choc']
    Max = row['Qty_penalty']
    
    profit = VS * PS + VM * PM + VL * PL + VCake * PCake + VChoc * PChoc
    if VS + VL + VM > 50:
        profit *= 0.9
    return profit
#Apply the function to each row and store the results in 'df1' / Aplicar funcion a cada fila y almacenar en df1
df1 = df.apply(getprofit1, axis=1)


```

Additionally we wil generate a graphic showing the distribution of the PROFIT and other statistics.

![Gauss](/Assets/2.png)


## Example 3 Sensitivity Analysis 
This is a basic example on how to determine sensitivity of each variable  using a 1% perturbation
What we need to determine is how can a small change in each variable affect the profit expressed in percentage.

```

# we wil use the profit function / Usaremos la funcion de utilidad
def getprofit(VS,VM,VL, PS,PM,PL, VCake,VChoc, PCake,PChoc, Max):
    profit=VS*PS+VM*PM+VL*PL+VCake*PCake+VChoc*PChoc
    if VS+VL+VM>50:
        profit==0.9*profit
    return profit


Xvals = {
    'QtySmall': 20,
    'QtyMedium': 15,
    'QtyLarge': 10,
    'PriceSmall': 5,
    'PriceMedium': 7,
    'PriceLarge': 10,
    'QtyCake': 0.05 * (20 + 15 + 10),
    'QtyChoc': 0.10 * (20 + 15 + 10),
    'PriceCake': 10,
    'PriceChoc': 3,
    'QtyPentalty': 50
}
S = sensitivity_analysis(getprofit, Xvals)
```
![Bar](/Assets/3.png)

## Conclusion
**Understanding Uncertainty**: Monte Carlo simulation allows us to incorporate uncertainty into our models by sampling from probability distributions for input variables. This helps us gain insights into the range of possible outcomes and their likelihoods.

**Risk Assessment**: By running multiple simulations, we can assess the risk associated with different scenarios. This is particularly valuable in fields like finance, where understanding and managing risk is crucial for decision-making.

**Sensitivity Analysis**: Monte Carlo simulation enables us to perform sensitivity analysis by varying input parameters and observing how they affect the output. Identifying which parameters have the greatest impact on the results can help prioritize resources and focus efforts on the most influential factors.

**Complex System Modeling:** Monte Carlo simulation is well-suited for modeling complex systems with multiple interacting variables. It provides a flexible framework for capturing the interdependencies between variables and understanding how they contribute to overall system behavior.

**Decision Support:** Monte Carlo simulation provides decision-makers with valuable insights into the potential outcomes of different courses of action. By quantifying the uncertainty associated with various options, it helps inform decision-making and mitigate the potential for unexpected outcomes.

**Resource Allocation:** Understanding the probabilistic distribution of outcomes allows for more informed resource allocation decisions. Whether it's budgeting for a project or determining inventory levels, Monte Carlo simulation helps optimize resource allocation strategies in the face of uncertainty.

**Communication of Results:** Monte Carlo simulation facilitates the communication of results by providing visualizations such as histograms, probability density functions, and cumulative distribution functions. These visual aids help stakeholders understand the implications of different scenarios and make more informed decisions.

In summary, Monte Carlo simulation is a powerful tool for analyzing uncertainty, assessing risk, and making informed decisions in a wide range of applications. Its ability to model complex systems and quantify uncertainty makes it invaluable for decision-makers across various industries.

******************************************************************************************************************************************************************
# SIMULACIÓN MONTE CARLO EN PYTHON Y R
 ### *Este es un ejemplo básico del uso de la Simulación de Monte carlo en Python y R* 
 *por Diego Gamarra Rivera* 

La simulación de Monte Carlo es una técnica computacional utilizada para modelar la probabilidad de diferentes resultados en un proceso que no puede predecirse fácilmente debido a la intervención de variables aleatorias. Recibe su nombre del famoso Casino Monte Carlo en Mónaco, conocido por sus juegos de azar, ya que la aleatoriedad juega un papel clave en la simulación.

La idea básica detrás de la simulación de Monte Carlo es utilizar métodos de muestreo aleatorio para resolver problemas que podrían ser deterministas en principio, pero que son demasiado complejos para resolver analíticamente. Implica ejecutar numerosas simulaciones de un modelo con entradas aleatorias, y luego analizar los resultados para comprender el rango de posibles resultados y sus probabilidades.

Aquí hay un proceso simplificado paso a paso de cómo funciona la simulación de Monte Carlo:

**Definir parámetros de entrada**: Identificar las variables que afectan el resultado del sistema y definir sus distribuciones de probabilidad.

**Generar entradas aleatorias**: Muestrear valores aleatorios de las distribuciones de probabilidad definidas para cada variable de entrada.

**Ejecutar simulaciones**: Utilizar los valores de entrada muestreados como entradas al modelo y ejecutar la simulación. Repetir este proceso para un gran número de iteraciones.

**Analizar resultados**: Recopilar las salidas de cada simulación y analizarlas para comprender el rango de posibles resultados y sus probabilidades. Esto podría implicar calcular estadísticas resumidas, construir histogramas o generar funciones de densidad de probabilidad.

**Sacar conclusiones**: Basándonos en los resultados de las simulaciones, sacar conclusiones sobre el comportamiento del sistema y tomar decisiones o recomendaciones en consecuencia.

La simulación de Monte Carlo se utiliza ampliamente en diversos campos como finanzas, ingeniería, física e investigación operativa para analizar sistemas y tomar decisiones informadas ante la incertidumbre. Es particularmente valiosa cuando se trata de sistemas complejos con múltiples variables interactivas y parámetros inciertos.

Usaremos la simulación de Monte Carlo en 2 ejemplos con Python y R 

## Ejemplo 1 

En este ejemplo tenemos un triángulo formado por 3 barras, cada barra tiene una longitud de 100 unidades y la tolerancia de fabricación es +-1 unidad, en este ejemplo asumimos que la desviación estándar es 1/3, con el único propósito de que el 99.73% de los datos caigan dentro de la tolerancia de fabricación. Necesitamos proporcionar la distribución y la media de uno de los ángulos del triángulo considerando que las barras no serán perfectamente de 100 unidades debido a la variabilidad del proceso.
En una situación real, la tolerancia de fabricación sería proporcionada por el cliente y la desviación estándar sería el resultado del cálculo realizado sobre el proceso.
Entonces, para este ejemplo simularemos valores aleatorios de barras para calcular valores simulados del ángulo, considerando que siguen una distribución normal, almacenamos esos valores en arrays y calculamos la media y la desviación estándar del ángulo
```
import numpy as np
import pandas as pd
AB=np.random.normal(100, 1/3, 1000)
AC=np.random.normal(100, 1/3, 1000)
CB=np.random.normal(100, 1/3, 1000)

# Applying the cosine law
AngleC = np.arccos((CB**2 + AC**2 - AB**2) / (2 * CB * AC))

# Converting radians to degrees
AngleC_deg = np.degrees(AngleC)

# Calculating mean and standard deviation
mean_angle = np.mean(AngleC_deg)
std_dev_angle = np.std(AngleC_deg)
print('Mean of angle C:', mean_angle)
print('Standard deviation of angle C:',std_dev_angle)

```

Además, generaremos un gráfico que muestre la distribución del ángulo y otras estadísticas.

![Gauss](/Assets/1.png)



## Ejemplo 2
Para el segundo ejemplo, tendremos un negocio que tiene 3 tipos de productos (Pequeño, Mediano y Grande) con pedidos promedio diarios (20, 15, 10) y ganancias ($5, $7, $10) adicionalmente 2 productos expresados como porcentaje del total de pedidos: Pedidos de Tortas (Ganancia: $10) - 5% de los pedidos, Chocolates (Ganancia: $3) - 10% de los pedidos. Además, tenemos una restricción: Si el negocio vende más de 50 ramos en un día, los costos de manejo son el 10% de la ganancia. En este caso, necesitaremos simular esas variables para obtener la ganancia promedio en un año (365 días), las variables siguen distribución poisson y binomial.

```
# Simulate values following poisson and binomial distribution. / Simulamos los valores siguiendo distribucions de Poisson y Binomial.
n=365
xVS = np.random.poisson(VS, n)
xVM = np.random.poisson(VM, n)
xVL = np.random.poisson(VL, n)
xVCake = np.random.binomial(VS+VL+VM, XCake, n)
xVChoc = np.random.binomial(VS+VL+VM, XChoc, n)

# Create a data frame containing the simulated values and the fixed values like 'Price_Small' to perform the calculations 
#/ Crear un data frame que contiene los valores simulados y valores fijos como 'Price_small'
df = pd.DataFrame({ 
    'Qty_Small': xVS,
    'Qty_Medium':xVM,
    'Qty_Large':xVL,
    'Price_Small':5,
    'Price_Medium':7,
    'Price_Large':10,
    'Qty_Cake': xVCake,
    'Qty_Choc': xVChoc,
    'Price_Cake':10,
    'Price_Choc':3,
    'Qty_penalty':50

#Create the function to calculate the profit / Crear la funcion para calcular la utilidad
def getprofit1(row):
    VS = row['Qty_Small']
    VM = row['Qty_Medium']
    VL = row['Qty_Large']
    PS = row['Price_Small']
    PM = row['Price_Medium']
    PL = row['Price_Large']
    VCake = row['Qty_Cake']
    VChoc = row['Qty_Choc']
    PCake = row['Price_Cake']
    PChoc = row['Price_Choc']
    Max = row['Qty_penalty']
    
    profit = VS * PS + VM * PM + VL * PL + VCake * PCake + VChoc * PChoc
    if VS + VL + VM > 50:
        profit *= 0.9
    return profit
#Apply the function to each row and store the results in 'df1' / Aplicar funcion a cada fila y almacenar en df1
df1 = df.apply(getprofit1, axis=1)


```

Además, generaremos un gráfico que muestre la distribución de la GANANCIA y otras estadísticas.

![Gauss](/Assets/2.png)

## Ejemplo 3 Análisis de Sensibilidad 
Este es un ejemplo básico sobre cómo determinar la sensibilidad de cada variable usando una perturbación del 1%
Lo que necesitamos determinar es cómo un pequeño cambio en cada variable puede afectar la ganancia expresada en porcentaje.

```

# we wil use the profit function / Usaremos la funcion de utilidad
def getprofit(VS,VM,VL, PS,PM,PL, VCake,VChoc, PCake,PChoc, Max):
    profit=VS*PS+VM*PM+VL*PL+VCake*PCake+VChoc*PChoc
    if VS+VL+VM>50:
        profit==0.9*profit
    return profit


Xvals = {
    'QtySmall': 20,
    'QtyMedium': 15,
    'QtyLarge': 10,
    'PriceSmall': 5,
    'PriceMedium': 7,
    'PriceLarge': 10,
    'QtyCake': 0.05 * (20 + 15 + 10),
    'QtyChoc': 0.10 * (20 + 15 + 10),
    'PriceCake': 10,
    'PriceChoc': 3,
    'QtyPentalty': 50
}
S = sensitivity_analysis(getprofit, Xvals)
```
Generamos un gráfico de barras para visualizar la sensibilidad de las variables.
![Bar](/Assets/3.png)


## Conclusión
**Comprensión de la incertidumbre**: La simulación de Monte Carlo nos permite incorporar incertidumbre en nuestros modelos muestreando de las distribuciones de probabilidad para las variables de entrada. Esto nos ayuda a comprender el rango de posibles resultados y sus probabilidades.

**Evaluación de riesgos**: Al ejecutar múltiples simulaciones, podemos evaluar el riesgo asociado con diferentes escenarios. Esto es particularmente valioso en campos como las finanzas, donde comprender y gestionar el riesgo es crucial para la toma de decisiones.

**Análisis de Sensibilidad**: La simulación de Monte Carlo nos permite realizar análisis de sensibilidad al variar los parámetros de entrada y observar cómo afectan el resultado. Identificar qué parámetros tienen el mayor impacto en los resultados puede ayudar a priorizar recursos y enfocar esfuerzos en los factores más influyentes.

**Modelado de sistemas complejos**: La simulación de Monte Carlo es adecuada para modelar sistemas complejos con múltiples variables interactivas. Proporciona un marco flexible para capturar las interdependencias entre variables y comprender cómo contribuyen al comportamiento general del sistema.

**Apoyo a la toma de decisiones**: La simulación de Monte Carlo proporciona a los tomadores de decisiones información valiosa sobre los posibles resultados de diferentes cursos de acción. Al cuantificar la incertidumbre asociada con diversas opciones, ayuda a informar la toma de decisiones y mitigar el potencial de resultados inesperados.

**Asignación de recursos**: Comprender la distribución probabilística de los resultados permite tomar decisiones de asignación de recursos más informadas. Ya sea presupuestando para un proyecto o determinando niveles de inventario, la simulación de Monte Carlo ayuda a optimizar estrategias de asignación de recursos frente a la incertidumbre.

**Comunicación de resultados**: La simulación de Monte Carlo facilita la comunicación de resultados al proporcionar visualizaciones como histogramas, funciones de densidad de probabilidad y funciones de distribución acumulativa. Estas ayudas visuales ayudan a los interesados a comprender las implicaciones de diferentes escenarios y tomar decisiones más informadas.

En resumen, la simulación de Monte Carlo es una herramienta poderosa para analizar la incertidumbre, evaluar el riesgo y tomar decisiones informadas en una amplia gama de aplicaciones. Su capacidad para modelar sistemas complejos y cuantificar la incertidumbre la hace invaluable para los tomadores de decisiones en diversas industrias.

