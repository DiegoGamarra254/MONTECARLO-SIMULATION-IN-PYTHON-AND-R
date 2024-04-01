# MONTECARLO SIMULATION IN PYTHON AND R
 * *This is a basic example of the use of the Montecarlo Simulation in Python and R* *
 
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

/assets/1.png

# Example 2
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

/assets/2.png


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
/assets/3.png

## Conclusion
**Understanding Uncertainty**: Monte Carlo simulation allows us to incorporate uncertainty into our models by sampling from probability distributions for input variables. This helps us gain insights into the range of possible outcomes and their likelihoods.

**Risk Assessment**: By running multiple simulations, we can assess the risk associated with different scenarios. This is particularly valuable in fields like finance, where understanding and managing risk is crucial for decision-making.

**Sensitivity Analysis**: Monte Carlo simulation enables us to perform sensitivity analysis by varying input parameters and observing how they affect the output. Identifying which parameters have the greatest impact on the results can help prioritize resources and focus efforts on the most influential factors.

**Complex System Modeling:** Monte Carlo simulation is well-suited for modeling complex systems with multiple interacting variables. It provides a flexible framework for capturing the interdependencies between variables and understanding how they contribute to overall system behavior.

**Decision Support:** Monte Carlo simulation provides decision-makers with valuable insights into the potential outcomes of different courses of action. By quantifying the uncertainty associated with various options, it helps inform decision-making and mitigate the potential for unexpected outcomes.

**Resource Allocation:** Understanding the probabilistic distribution of outcomes allows for more informed resource allocation decisions. Whether it's budgeting for a project or determining inventory levels, Monte Carlo simulation helps optimize resource allocation strategies in the face of uncertainty.

**Communication of Results:** Monte Carlo simulation facilitates the communication of results by providing visualizations such as histograms, probability density functions, and cumulative distribution functions. These visual aids help stakeholders understand the implications of different scenarios and make more informed decisions.

In summary, Monte Carlo simulation is a powerful tool for analyzing uncertainty, assessing risk, and making informed decisions in a wide range of applications. Its ability to model complex systems and quantify uncertainty makes it invaluable for decision-makers across various industries.

