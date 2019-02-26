#data exploration

#bivariate analysis

#Target variable Vs independent categorical variables
bank_train_corr <- cor(bank_marketing_data())
corrplot(BM_train_corr, method = "pie", type = "lower", tl.cex = 0.9)

b1 <- chisq.test(bank_marketing_data$job, bank_marketing_data$y)
plot_b1 <- corrplot(b1$residuals, is.corr = FALSE, title = "Job Vs y", mar=c(0,0,1,0))

b2 <- chisq.test(bank_marketing_data$marital, bank_marketing_data$y)
plot_b2 <- corrplot(b2$residuals, is.corr = FALSE, title = "Marital Vs y", mar=c(0,0,1,0))

b3 <- chisq.test(bank_marketing_data$education, bank_marketing_data$y)
plot_b3 <- corrplot(b3$residuals, is.corr = FALSE, title = "Education Vs y", mar=c(0,0,1,0))

b4 <- chisq.test(bank_marketing_data$default, bank_marketing_data$y)
plot_b4 <- corrplot(b4$residuals, is.corr = FALSE, title = "Default Vs y", mar=c(0,0,1,0))

b5 <- chisq.test(bank_marketing_data$housing, bank_marketing_data$y)
plot_b5 <- corrplot(b5$residuals, is.corr = FALSE, title = "Housing Loan Vs y", mar=c(0,0,1,0))

b6 <- chisq.test(bank_marketing_data$loan, bank_marketing_data$y)
plot_b6 <- corrplot(b6$residuals, is.corr = FALSE, title = "Personal Loan Vs y", mar=c(0,0,1,0))

b7 <- chisq.test(bank_marketing_data$contact, bank_marketing_data$y)
plot_b7 <- corrplot(b7$residuals, is.corr = FALSE, title = "Contact Vs y", mar=c(0,0,1,0))

b8 <- chisq.test(bank_marketing_data$month, bank_marketing_data$y)
plot_b8 <- corrplot(b8$residuals, is.corr = FALSE, title = "Month Vs y", mar=c(0,0,1,0))

b9 <- chisq.test(bank_marketing_data$day_of_week, bank_marketing_data$y)
plot_b9 <- corrplot(b9$residuals, is.corr = FALSE, "day_of_week Vs y", mar=c(0,0,1,0))

b10 <- chisq.test(bank_marketing_data$poutcome, bank_marketing_data$y)
plot_b10 <- corrplot(b10$residuals, is.corr = FALSE, title = "poutcome Vs y", mar=c(0,0,1,0))

#Target variable Vs independent numerical variables
b11 <- ggplot(bank_marketing_data, aes(factor(y), age)) + geom_boxplot(aes(fill = factor(y)))
b11

b12 <- ggplot(bank_marketing_data, aes(factor(y), campaign)) + geom_boxplot(aes(fill = factor(y)))
b12

b13 <- ggplot(bank_marketing_data, aes(factor(y), cons.conf.idx)) + geom_boxplot(aes(fill = factor(y)))
b13

b14 <- ggplot(bank_marketing_data, aes(factor(y), cons.price.idx)) + geom_boxplot(aes(fill = factor(y)))
b14

b15 <- ggplot(bank_marketing_data, aes(factor(y), emp.var.rate)) + geom_boxplot(aes(fill = factor(y)))
b15

b16 <- ggplot(bank_marketing_data, aes(factor(y), euribor3m)) + geom_boxplot(aes(fill = factor(y)))
b16

b17 <- ggplot(bank_marketing_data, aes(factor(y), nr.employed)) + geom_boxplot(aes(fill = factor(y)))
b17

b18 <- ggplot(bank_marketing_data, aes(factor(y), previous)) + geom_boxplot(aes(fill = factor(y)))
b18

#combining the above plots

row_4 <- plot_grid(b18, b17, nrow = 1)
row_3 <- plot_grid(b16, b15, nrow = 1)
row_2 <- plot_grid(b14, b13, nrow = 1)
row_1 <- plot_grid(b12, b11, nrow = 1)
combined_plot_4 <- plot_grid(row_1, row_2, row_3, row_4, ncol = 1) 
combined_plot_4
