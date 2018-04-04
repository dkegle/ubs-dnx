data {

  int n;
  vector[n] y;
  
  // real theta_lb;
  // real theta_ub;
  real mu1_lb; // 0.6 - 0.9
  real mu1_ub; // 1
  real sigma1_lb; // 0
  real sigma1_ub;
  real mu2_lb; 
  real mu2_ub; 
  real sigma2_lb; // 0
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
  
  //theta ~ beta(0.5, 0.5);
  theta ~ uniform(0, 1);
  mu1 ~ uniform(mu1_lb, mu1_ub);
  sigma1 ~ uniform(sigma1_lb, sigma1_ub);
  mu2 ~ uniform(mu2_lb, mu2_ub);
  sigma2 ~ uniform(sigma2_lb, sigma2_ub);
  

  // normal - skew normal mixture
  for (i in 1:n){
     target += log_mix(theta,
                     normal_lpdf(y[i] | mu1, sigma1),
                     normal_lpdf(y[i] | mu2, sigma2));
  }
}
