data {

  int n;
  vector[n] y;
  
  // real theta_lb;
  // real theta_ub;
  real mu_lb; // 0.6 - 0.9
  real mu_ub; // 1
  real sigma_lb; // 0
  real sigma_ub; 
  real xi_lb; // 0
  real xi_ub; // 1
  real omega_lb; // 0
  real omega_ub; 
  real alpha_lb; // negative
  real alpha_ub; // positive

}
parameters {
  real<lower = 0.0, upper = 1.0> theta;
  real<lower = 0.0> mu;
  real<lower = 0.0> sigma;
  real<lower = 0.0> xi;
  real<lower = 0.0> omega;
  real alpha;
}

// 6 parametric model
model {
  
  //theta ~ beta(0.5, 0.5);
  theta ~ uniform(0, 1);
  mu ~ uniform(mu_lb, mu_ub);
  sigma ~ uniform(sigma_lb, sigma_ub);
  
  xi ~ uniform(xi_lb, xi_ub);
  omega ~ uniform(omega_lb, omega_ub);
  alpha ~ uniform(alpha_lb, alpha_ub);
  
  // normal - skew normal mixture
  for (i in 1:n){
     target += log_mix(theta,
                     normal_lpdf(y[i] | mu, sigma),
                     skew_normal_lpdf(y[i] | xi, omega, alpha));
  }
}
