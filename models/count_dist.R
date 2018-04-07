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



y1<-c(length(all_sticks1), length(all_sticks2)) 
y2<-c(length(all_sticks3), length(all_sticks4)) #thrown packs



library("rstan") # observe startup messages
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())


# Prepare dataset for STAN
stan_data1 <- list(y = y1,
                  n = length(y1))

stan_data2 <- list(y = y2,
                   n = length(y2))

# Sample
output1 <- stan(file = "normal.stan",
               data = stan_data1,
               iter = 1500, warmup = 500,
               chains = 4,
               seed = 100,
               control = list(adapt_delta = 0.9))

output2 <- stan(file = "normal.stan",
                data = stan_data2,
                iter = 1500, warmup = 500,
                chains = 4,
                seed = 100,
                control = list(adapt_delta = 0.9))

# Diagnostics & Posterior inference
traceplot(output1)
plot(output1)
print(output1)
ggplot()+geom_density(aes(x=extract(output1)$y_pred))+xlim(0, 1000)

traceplot(output2)
plot(output2)
print(output2)
ggplot()+geom_density(aes(x=extract(output2)$y_pred))+xlim(0, 1000)


summary(output1)$summary["mu", "mean"] # mean for 1. pack
summary(output1)$summary["mu", "se_mean"] #and MCMC standard error 
summary(output1)$summary["mu", "sd"] #sd. dev. 

summary(output2)$summary["mu", "mean"] # mean for 2. pack
summary(output2)$summary["mu", "se_mean"] #and MCMC standard error
summary(output2)$summary["mu", "sd"] #sd. dev. 

