import numpy as np
from genetic import GeneticLinearRegressor

np.random.seed(123)
sample_num = 4
beta_true = [10, 3]

x_obs = np.random.normal(25, 10, sample_num)
y_obs = beta_true[0] + beta_true[1]*x_obs + np.random.normal(0, 10, sample_num)

def test_obs():
    np.testing.assert_allclose(x_obs, np.array([14.14369397, 34.97345447, 27.82978498, 9.93705286]), rtol=1e-4)
    np.testing.assert_allclose(y_obs, np.array([46.64507938, 131.43472877, 69.22256251, 35.52203229]), rtol=1e-4)

def test_glr():
    gen_size = 20
    glr = GeneticLinearRegressor(gen_size=gen_size)

    assert glr.gen_size == gen_size