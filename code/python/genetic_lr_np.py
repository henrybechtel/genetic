# Genetic Linear Regression with Numpy
# A solution... via evolution!

import numpy as np
import matplotlib.pyplot as plt
# import genetic as gn


sample_num = 10
beta_true = [2, 3]

x_obs = np.random.normal(25, 10, sample_num)
y_obs = beta_true[0] + beta_true[1]*x_obs + np.random.normal(0, 10, sample_num)



class GeneticLinearRegressor:
    def __init__(self, gen_size=10):
        self.gen_size = gen_size
        self.init_beta_mean = 0
        self.init_beta_std = 10
        self.betas = np.random.normal(self.init_beta_mean, self.init_beta_std, (self.gen_size, 2))
    def rmse_fitness(self, beta):
        y_hat = beta[0] + x_obs*beta[1]
        rmse = np.sqrt(np.mean((y_hat - y_obs)**2))
        return rmse
    def rank(self):
        scored = np.column_stack((self.betas, np.apply_along_axis(self.rmse_fitness, axis=1, arr=betas)))
        ranked = scored[scored[:, 2].argsort()]
        return ranked
    def select(self, ranked, frac):
        top_num = int(frac*ranked.shape[0])
        survivors = ranked[:top_num]
        return survivors
    def mate(self, survivors, gen_size):
        rank_weighting = np.linspace(1, 0, survivors.shape[0])
        rank_weighting /= rank_weighting.sum()
        sampled_b0 = np.random.choice(survivors[:,0], size=gen_size, replace=True, p=rank_weighting)
        sampled_b1 = np.random.choice(survivors[:,1], size=gen_size, replace=True, p=rank_weighting)
        sampled_betas = np.column_stack((sampled_b0, sampled_b1))
        # mutation
        mutation = np.random.normal(0, 1, (gen_size, 2))
        # next generation
        new_betas = sampled_betas + mutation
        return new_betas
    def fit(self, x_obs, y_obs):
        self.best_fit_hist = []
        verbose = True
        for gen in range(5):
            if verbose:
                print(f"Generation: {gen}")
            # ranking
            ranked = self.rank()
            self.best_fit_hist.append(ranked[0][2])
            # selection
            survivors = self.select(ranked, 0.2)
            if verbose:
                print(f"survivors:\n {survivors}")
            # crossover and mutation -> next generation
            self.betas = self.mate(survivors, self.gen_size)
            if verbose:
                print(f"next betas: \n {self.betas[:10]}")
                print('\n')



glr = GeneticLinearRegressor()
glr.gen_size
glr.betas

glr.fit(x_obs, y_obs)
glr.best_fit_hist

