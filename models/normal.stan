data {
  int n;
  vector[n] y;
}

parameters {
  real<lower = 0.0> mu;
  real<lower = 0.0> sigma;
}

// 2 parametric model
model {
  
  // normal LH
  for (i in 1:n){
     target += normal_lpdf(y[i] | mu, sigma);
  }
  //Jeffrey's prior
  target +=-log(sigma);
}

generated quantities{
  // posterior predictive
  real y_pred;
  y_pred = normal_rng(mu, sigma);
}



