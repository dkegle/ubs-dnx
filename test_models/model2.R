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
                  mu1_lb = 0.75, # 0.6 - 0.9 TODO FIX
                  mu1_ub = 1,
                  sigma1_lb = 0,
                  sigma1_ub = 100,
                  mu2_lb = 0,
                  mu2_ub = 0.75,
                  sigma2_lb = 0,
                  sigma2_ub = 500)

# Sample
output <- stan(file = "model2.stan",
               data = stan_data,
               iter = 4000, warmup = 2000,
               chains = 1,
               seed = 0,
               control = list(adapt_delta = 0.80))

# Diagnostics & Posterior inference
traceplot(output)
plot(output)
print(output)


