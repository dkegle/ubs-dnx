data {

  int n;
  vector[n] y;
  
  real mu1_lb;
  real mu1_ub;
  real sigma1_lb;
  real sigma1_ub;
  real mu2_lb; 
  real mu2_ub; 
  real sigma2_lb;
  real sigma2_ub;


}
parameters {
  real<lower = 0.0, upper = 1.0> theta;
  real<lower = 0.0> mu1;
  real<lower = 0.0> sigma1;
  real<lower = 0.0> mu2;
  real<lower = 0.0> sigma2;
}

// 5 parametric model
model {
  
  //priors
  theta ~ uniform(0, 1);
  mu1 ~ uniform(mu1_lb, mu1_ub);
  sigma1 ~ uniform(sigma1_lb, sigma1_ub);
  mu2 ~ uniform(mu2_lb, mu2_ub);
  sigma2 ~ uniform(sigma2_lb, sigma2_ub);
  

  // normal - normal mixture LH
  for (i in 1:n){
     target += log_mix(theta,
                     normal_lpdf(y[i] | mu1, sigma1),
                     normal_lpdf(y[i] | mu2, sigma2));
  }
}

generated quantities{
  // posterior predictive
  real x_pred;
  real y_pred;
  x_pred = bernoulli_rng(theta);
  y_pred = x_pred * normal_rng(mu1, sigma1) +
          (1 - x_pred) * normal_rng(mu2, sigma2);
}



