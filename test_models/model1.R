sticks <- read.csv(file="vrecka-1.csv", header=TRUE, sep=",")
all_sticks<-c(sticks$cela, sticks$sredina.zlomljene, sticks$konec.zlomljen)
all_sticks <- all_sticks[!is.na(all_sticks)]

length_of_packed <- 15 # TODO FIX
y<-all_sticks/length_of_packed


library("rstan") # observe startup messages
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())


# Prepare dataset for STAN
stan_data <- list(y = y,
                  n = length(y),
                  mu_lb = 0.75, # 0.6 - 0.9 TODO FIX
                  mu_ub = 1,
                  sigma_lb = 0,
                  sigma_ub = 100, 
                  xi_lb = 0,
                  xi_ub = 0.75,
                  omega_lb = 0,
                  omega_ub = 500, 
                  alpha_lb = -10,
                  alpha_ub = 10)

# Sample
output <- stan(file = "model1.stan",
               data = stan_data,
               iter = 4000, warmup = 2000,
               chains = 4,
               seed = 0,
               control = list(adapt_delta = 0.99))

# Diagnostics & Posterior inference
traceplot(output)
plot(output)
print(output)


