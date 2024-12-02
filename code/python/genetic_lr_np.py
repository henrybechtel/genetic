# Genetic Linear Regression with Numpy
# A solution... via evolution!

import os 
import numpy as np
import matplotlib.pyplot as plt
from genetic import GeneticLinearRegressor

os.listdir()
os.chdir('app/code/python')

sample_num = 10
beta_true = [2, 3]

x_obs = np.random.normal(25, 10, sample_num)
y_obs = beta_true[0] + beta_true[1]*x_obs + np.random.normal(0, 10, sample_num)



glr = GeneticLinearRegressor()
glr.gen_size
glr.betas
glr.fit(x_obs, y_obs)

glr.x_obs

glr.rank()

glr.best_fit_hist

