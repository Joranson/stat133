<style>
  .reveal pre {font-size: 12px;}
</style>

Simulation
========================================================
author: Stat133
date: 24 Feb 2015
transition: none
#font-family: 'Garamond'

Statistics
===
Statistics is the 
- collection 
- organization 
- analysis 
- interpretation
of data

## Descriptive Statistics: 
summarize data (e.g. using mean, sd, histogram, …)
## Inferential Statistics: 
use data to answer specific questions, often by hypothesis testing.

Examples of Statistical Tests
===
- Does the data come from a Normal distribution with mean μ0 ?
- Do two or more samples come from the same distribution? (e.g. comparing drug and placebo, or gene expression in two different samples).  T-test or ANOVA
- Independence in a contingency table (is final grade independent of major?)
- Is the coefficient in a (linear) regression equal to 0?  i.e. should the variable be in the model.
- Hazard rate tests.

Inferential Statistics
===
Assume data is a random sample from a (given) *probability distribution* (like Normal, Binomial, *t*, Poisson, ...).

A *statistic* is a function of this random sample, e.g. the mean, median or quantile, variance, max, min, z-statistic, t-statistic.  
Think of a statistic as a scalar summary of the observations.

Often we use the statistic to estimate the value of a *parameter* of the distribution.

Inferential Statistics cont'd
===
- Statistics are often used as *estimators* of quantities of interest about the distribution, called parameters.  

- Statistics are random variables (since they depend on the sample); parameters are not.

- In simple cases, we can study the sampling distribution of the statistic analytically.  For example, we can prove that under mild conditions the distribution of the sample proportion is close to normal for large sample sizes. 


Conventional Statistics
===
All of these tests depend on the samples (our data) being drawn at random from a larger population and that we can describe it with an underlying probability distribution. 

Not so Conventional
===
- In more complicated cases, we turn to simulation.

- The main idea in a simulation study is to replace the mathematical expression for the distribution with a sample from that distribution.

- Example: $x_1, x_2, ..., x_n$ are independent observations from the same distribution.  The distribution has center $\mu$ (mean/expected value) and spread $\sigma$ (standard deviation)

- We are interested in the distribution of, say, $\sigma$ so we take many samples of size $n$, and study the behavior of the sample averages

- We use the sample to estimate features of the distribution, such as the behavior of various statistics under repeated sampling from the distribution.




Resampling
===
Form statistical estimates by taking random samples directly from the data at hand.

That is: You randomly sample your random sample! 

Thus the *re* in resampling.

Resampling is a broad term that refers to techniques which use repeated samples from some distribution.  

Each sample, treated as a pseudo-data set, is analyzed in some way (perhaps just summarized) and by repeating this process, getting slightly different results each time, we can get some idea of the variability in whatever we’re doing.

Resampling is a general term
===
Some common resampling methods are:
- Bootstrapping
- Jackknifing
- Cross-validation
- Permutation tests
- Monte-Carlo methods

Terminology
===
Simulation, resampling: what’s the difference?

In simulations we substitute a real random situation (traffic, meteorology) by a different experiment, which is a model for the original but can easily be manipulated and analyzed.  

We “run” this model and record the state of the system in each step.

Resampling is a simulation method, but resampling is a more narrow term.

Uses of Simulation Studies
===
- Public Health: Spread of Ebola, HIV or other diseases.
- Population Genetics: Estimate the time it takes a new mutation to become fixed in the population.
- Traffic : Predict where traffic jams occur, and under which conditions.

Back to resampling
===
Resampling methods are used e.g. to
estimate the precision of sample statistics
- by sampling with replacement from data (bootstrapping)
- by using subsets of available data (jackknifing)
- exchange labels on data points in permutation tests
- validating models using random subsets (cross-validation, bootstrapping) 

Bootstrap 
===
Assume you have a random sample of e.g. heights of people.  

The mean is a commonly used estimator of the average height.

How to we estimate the variance (var) of this estimator (NB not the variance of the distribution), or get a *confidence interval* (CI) around the mean? (In other words, how good is this guess?)

In conventional statistics we would assume that the data is normally distributed and under that assumption calculate the variance and CI.

The Bootstrap Idea
===
The original sample, say of 10 heights, approximates the population.  

If we replicate sample values to build up an approximate population, we can then sample repeatedly from this population.  

We then get many samples of size 10 and treat each as a new pseudo-data set and the average is computed.  

The distribution of the sample averages now gives some idea of what the sample average could have been if a different set of 10 students were chosen.

Bootstrap
===
With the Bootstrap we resample (sample with replacement) from the sample, for each new sample calculate the mean, and use that to get a variance estimate.

- Data : x=(x1, x2, …, xn)
- Sample mean : xbar
- Bootstrap samples : yi=(x3, x9, …, x7)
- Means of bootstrap samples: y1bar, y2bar, …, ymbar

This is an *empirical sample distribution* for the sample mean and we can estimate the *variance* and *CI* based on this.

Cross-Validation
===
A *model validation* technique.

- Split your data in training and testing data
- Use the training set to fit a model (e.g. linear model) and get parameter estimates (e.g. slope and intercept).
- Now check how well this model fits the test data, usually not as well as the training data.

The cross-validation estimator is one that minimizes the cross-validation error.  We may revisit CV in a later homework.

Cross-Validation cont'd
===

Using the same data to create the model as well as assess the model can lead to an overly optimistic view of how well the model will be able to make predictions in an independent data set.  

The idea of CV is to leave some data aside as a test set (to assess the predictions) while the rest of the data is a training set used to make decisions about how to make predictions.

Monte Carlo
===
Monte Carlo Methods are not technically resampling, but they are related. 

Used e.g. by sampling repeatedly from a *known* distribution that we assume is *true* and then we compare our observed data to the Monte Carlo samples.

We will revisit this later.

More Information
===
Read the wikipedia pages on resampling and the specific subjects listed here.

Book: An Introduction to Statistical Learning: with Applications in R by James, Witten, Hastie and Tibshirani.



How does R generate random numbers?
===
Actually, it doesn’t!  R uses a pseudo random number generator:

- It starts with a seed and an algorithm (i.e. a function)  
- The seed is plugged into the algorithm and a number is returned
- That number is then plugged into the algorithm and the next number is created

The algorithms are such that the numbers produced behave/look like random values

Simple Congruential Generator
===
The congruential method uses modular arithmetic to generate “random” numbers. 

From inputs $a$ and $b$ and an initial value, $x_0$ , the ﬁrst “random number” is generated as follows: 
$$x_1 = a \cdot x_0 \textrm{mod} b$$

and subsequent numbers are generated recursively, 
$$x_{(n+1)} = a \cdot x_n \textrm{mod} b$$

We call $x_0$ the seed

Simple Congruential Generator
===
Congruential a = 3,b = 64

Seed = 17

3 * 17 mod 64 = 51 mod 64 = 51

3 * 51 mod 64 = 153 mod 64 = 25

3 * 25 mode 64 = 75 mod 64 = 11

And so on.  The first 20 “random” numbers are
51 25 11 33 35 41 59 49 19 57 43  1  3  9 27 17 51 25 11 33



The Seed
===
There is one big advantage to pseudo-random number generators:

You can reproduce your simulation results by controlling the seed: 	
set.seed() allows you to do this:

When researchers publish results from simulation studies, they typically include the random number generator and the seed that was used so that others can verify/replicate their results


The Seed
===
> set.seed(69069)		Set the seed for the RNG

> runif(3)				Call the uniform RNG
[1] 0.1648855 0.9564664 0.3345479

> runif(3)				Call the uniform RNG again
[1] 0.01109596 0.18654873 0.94657805

> set.seed(69069)		Set the seed back to 69069
> runif(3)
[1] 0.1648855 0.9564664 0.3345479


