sticks1 <- read.csv(file="vrecka-1.csv", header=TRUE, sep=",")
all_sticks1 <-c(sticks1$cela, sticks1$sredina.zlomljene, sticks1$konec.zlomljen)
all_sticks1 <- all_sticks1[!is.na(all_sticks1)]

sticks2 <- read.csv(file="vrecka-2.csv", header=TRUE, sep=",")
all_sticks2 <-c(sticks2$cela, sticks2$sredina.zlomljene, sticks2$konec.zlomljen)
all_sticks2 <- all_sticks2[!is.na(all_sticks2)]

sticks3 <- read.csv(file="vrecka-3.csv", header=TRUE, sep=",")
all_sticks3 <-c(sticks3$cela, sticks3$sredina.zlomljene, sticks3$konec.zlomljen)
all_sticks3 <- all_sticks3[!is.na(all_sticks3)]

sticks4 <- read.csv(file="vrecka-4.csv", header=TRUE, sep=",")
all_sticks4 <-c(sticks4$cela, sticks4$sredina.zlomljene, sticks4$konec.zlomljen)
all_sticks4 <- all_sticks4[!is.na(all_sticks4)]



length_of_pack <- 16.5
y1<-all_sticks1/length_of_pack
y2<-all_sticks2/length_of_pack
y3<-all_sticks3/length_of_pack
y4<-all_sticks4/length_of_pack


library("rstan") # observe startup messages
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())


# Prepare dataset for STAN
stan_data1 <- list(y = y1,
                  n = length(y1),
                  mu1_lb = 0.5, 
                  mu1_ub = 1,
                  sigma1_lb = 0,
                  sigma1_ub = 100,
                  mu2_lb = 0,
                  mu2_ub = 0.5,
                  sigma2_lb = 0,
                  sigma2_ub = 500)

stan_data2 <- list(y = y2,
                   n = length(y2),
                   mu1_lb = 0.5, 
                   mu1_ub = 1,
                   sigma1_lb = 0,
                   sigma1_ub = 100,
                   mu2_lb = 0,
                   mu2_ub = 0.5,
                   sigma2_lb = 0,
                   sigma2_ub = 500)

stan_data3 <- list(y = y3,
                   n = length(y3),
                   mu1_lb = 0.5,
                   mu1_ub = 1,
                   sigma1_lb = 0,
                   sigma1_ub = 100,
                   mu2_lb = 0,
                   mu2_ub = 0.5,
                   sigma2_lb = 0,
                   sigma2_ub = 500)

stan_data4 <- list(y = y4,
                   n = length(y4),
                   mu1_lb = 0.5,
                   mu1_ub = 1,
                   sigma1_lb = 0,
                   sigma1_ub = 100,
                   mu2_lb = 0,
                   mu2_ub = 0.5,
                   sigma2_lb = 0,
                   sigma2_ub = 500)

# Sample
output1 <- stan(file = "mixed_normal.stan",
               data = stan_data1,
               iter = 4000, warmup = 2000,
               chains = 1,
               seed = 100,
               control = list(adapt_delta = 0.9))

output2 <- stan(file = "mixed_normal.stan",
                data = stan_data2,
                iter = 4000, warmup = 2000,
                chains = 1,
                seed = 100,
                control = list(adapt_delta = 0.9))

output3 <- stan(file = "mixed_normal.stan",
                data = stan_data3,
                iter = 4000, warmup = 2000,
                chains = 1,
                seed = 100,
                control = list(adapt_delta = 0.9))

output4 <- stan(file = "mixed_normal.stan",
                data = stan_data4,
                iter = 4000, warmup = 2000,
                chains = 1,
                seed = 100,
                control = list(adapt_delta = 0.9))

# Diagnostics & Posterior inference
traceplot(output1)
plot(output1)
print(output1)
ggplot()+geom_density(aes(x=extract(output1)$y_pred))+xlim(0, 1)

traceplot(output2)
plot(output2)
print(output2)
ggplot()+geom_density(aes(x=extract(output2)$y_pred))+xlim(0, 1)

traceplot(output3)
plot(output3)
print(output3)
ggplot()+geom_density(aes(x=extract(output3)$y_pred))+xlim(0, 1)

traceplot(output4)
plot(output4)
print(output4)
ggplot()+geom_density(aes(x=extract(output4)$y_pred))+xlim(0, 1)


library(mcmcse)

smp_y_pred1 <- extract(output1)$y_pred

print(ess(smp_y_pred1)) # effective sample size

print(mcse(smp_y_pred1))  # est. MCMC standard error


smp_y_pred2 <- extract(output2)$y_pred

print(ess(smp_y_pred2)) # effective sample size

print(mcse(smp_y_pred2))  # est. MCMC standard error


smp_y_pred3 <- extract(output3)$y_pred

print(ess(smp_y_pred3)) # effective sample size

print(mcse(smp_y_pred3))  # est. MCMC standard error


smp_y_pred4 <- extract(output4)$y_pred

print(ess(smp_y_pred4)) # effective sample size

print(mcse(smp_y_pred4))  # est. MCMC standard error


