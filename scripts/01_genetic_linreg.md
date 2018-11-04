Genetic Linear Regression
================
Henry Bechtel

A solution... via evolution!
----------------------------

Importing Libraries

``` r
library(ggplot2)
library(dplyr)
```

Generating Data

``` r
x <- rnorm(100, 30, 5)
y <- 3*x + 5 + rnorm(x, 0, 5)
```

Randomly generate a set of model coefficients

``` r
beta <- runif(2, -5, 5)
```

Visualizing how our data look

``` r
data.frame(x, y) %>%
    ggplot(aes(x,y)) + 
    geom_point() +
    geom_abline(intercept=beta[1], slope = beta[2])
```

![](01_genetic_linreg_files/figure-markdown_github/unnamed-chunk-4-1.png)

``` r
beta
```

    ## [1] -4.699591  1.823945

``` r
# Model prediction
yhat <- beta[1] + beta[2]*x

# Score
rmse <- sqrt(mean((y-yhat)^2))

rmse
```

    ## [1] 44.81166

Now with simple GA

``` r
# Generate population
total_pop <- 1000
population <- data.frame(beta0 = runif(total_pop, -100, 100), beta1 = runif(total_pop, -100, 100)) 

# Score population
population$rmse <- 0

for(generation in 1:50){
  for(i in 1:nrow(population)){
    population$rmse[i] <- sqrt(mean((y-(population$beta0[i] + population$beta1[i]*x))^2))
  }
  
  # Selection
  top_pop <- head(population[order(population$rmse),], total_pop/10)
  
  # Crossover
  population$beta0 <- sample(top_pop$beta0, total_pop, replace = TRUE)
  population$beta1 <- sample(top_pop$beta1, total_pop, replace = TRUE)
  
  # Mutation
  population$beta0 <- population$beta0 + rnorm(total_pop)
  population$beta1 <- population$beta1 + rnorm(total_pop)
}
```

Visualizing

``` r
data.frame(x, y) %>%
  ggplot(aes(x,y)) + 
  geom_point() +
  geom_abline(data = head(top_pop, 20), aes(intercept=beta0, slope = beta1, alpha = 0.1, color = rmse))
```

![](01_genetic_linreg_files/figure-markdown_github/unnamed-chunk-7-1.png)

``` r
head(top_pop)
```

    ##          beta0    beta1     rmse
    ## 23   0.5488911 3.122328 4.588295
    ## 497  2.5171267 3.040468 4.603602
    ## 368  4.3638219 3.007564 4.613082
    ## 569 -0.1676600 3.156144 4.614647
    ## 198  4.5977039 3.002063 4.622189
    ## 470 -0.6070796 3.171487 4.624350

``` r
paste("Estimate for beta0 is:  " , mean(top_pop$beta0))
```

    ## [1] "Estimate for beta0 is:   6.13032196598736"

``` r
paste("Estimate for beta1 is:  " , mean(top_pop$beta1))
```

    ## [1] "Estimate for beta1 is:   2.93614639936588"

``` r
paste("Estimate for beta0 SE is:  ", sd(top_pop$beta0))
```

    ## [1] "Estimate for beta0 SE is:   4.05071141167123"

``` r
paste("Estimate for beta1 SE is:  ", sd(top_pop$beta1))
```

    ## [1] "Estimate for beta1 SE is:   0.150721040328184"

Benchmark against lm

``` r
fit <- lm(y ~ x)
summary(fit)
```

    ## 
    ## Call:
    ## lm(formula = y ~ x)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -10.7376  -3.3919   0.2349   3.3356  11.5238 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  1.99208    2.72864    0.73    0.467    
    ## x            3.07228    0.08971   34.24   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 4.627 on 98 degrees of freedom
    ## Multiple R-squared:  0.9229, Adjusted R-squared:  0.9221 
    ## F-statistic:  1173 on 1 and 98 DF,  p-value: < 2.2e-16
