#Data Exploration

#univariate analysis

#visualizing the target variable
p1 <- ggplot(bank_marketing_data %>% group_by(y) %>% summarise(Count = n())) +
  geom_bar(aes(y, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(y, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  ggtitle("Term Deposit Subscription")

p1
#the target variable is highly imbalanced

#visualizing the categorical variable
#plot for job
p2 <- ggplot(bank_marketing_data %>% group_by(job) %>% summarise(Count = n())) +
  geom_bar(aes(job, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(job, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Type of Job")
p2

#plot for marital
p3 <- ggplot(bank_marketing_data %>% group_by(marital) %>% summarise(Count = n())) +
  geom_bar(aes(marital, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(marital, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Marital Status")
p3

#plot for education
p4 <- ggplot(bank_marketing_data %>% group_by(education) %>% summarise(Count = n())) +
  geom_bar(aes(education, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(education, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Education")
p4

#plot for default
p5 <- ggplot(bank_marketing_data %>% group_by(default) %>% summarise(Count = n())) +
  geom_bar(aes(default, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(default, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Credit in default")
p5

#plot for housing
p6 <- ggplot(bank_marketing_data %>% group_by(housing) %>% summarise(Count = n())) +
  geom_bar(aes(housing, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(housing, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  ggtitle("Possessing Housing Loan")
p6


#plot for loan
p7 <- ggplot(bank_marketing_data %>% group_by(loan) %>% summarise(Count = n())) +
  geom_bar(aes(loan, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(loan, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  ggtitle("Possessing Personal Loan")
p7

#plot for contact
p8 <- ggplot(bank_marketing_data %>% group_by(contact) %>% summarise(Count = n())) +
  geom_bar(aes(contact, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(contact, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  ggtitle("Contact Communication Type")
p8

#plot for month
p9 <- ggplot(bank_marketing_data %>% group_by(month) %>% summarise(Count = n())) +
  geom_bar(aes(month, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(month, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  ggtitle("Last Contacted Month")
p9

#plot for day
p10 <- ggplot(bank_marketing_data %>% group_by(day_of_week) %>% summarise(Count = n())) +
  geom_bar(aes(day_of_week, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(day_of_week, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  ggtitle("Last Contacted Day")
p10

#plot for poutcome
p11 <- ggplot(bank_marketing_data %>% group_by(poutcome) %>% summarise(Count = n())) +
  geom_bar(aes(poutcome, Count), stat = "identity", fill = "indianred1") +
  xlab("") +
  geom_label(aes(poutcome, Count, label = Count), vjust = 0.5) +
  theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
  ggtitle("Outcome of Previous Campaign")
p11

#combining the above plots
forth_row <- plot_grid(p10, p11, p9, nrow = 1)
third_row <- plot_grid(p8, p7, p6, nrow = 1)
second_row <- plot_grid(p5, p4, p3, nrow = 1)
first_row <- p2
combined_plot_1 <- plot_grid(p2, second_row, ncol = 1)
combined_plot_2 <- plot_grid(third_row, forth_row, ncol = 1)
combined_plot_1
combined_plot_2

#visualizing numeric data

#plot of age
p12 <- ggplot(bank_marketing_data) + geom_histogram(aes(bank_marketing_data$age),
                                                    binwidth = 0.5, fill = "palegreen3") + xlab ("Age")
p12

#plot for campaign
p13 <- ggplot(bank_marketing_data) + geom_histogram(aes(bank_marketing_data$campaign),
                                                    binwidth = 1.5, fill = "palegreen3") + xlab ("Campaign")
p13

#plot for previous
p14 <- ggplot(bank_marketing_data) + geom_histogram(aes(bank_marketing_data$previous),
                                                    binwidth = 0.5, fill = "palegreen3") + xlab ("Previous")
p14

#plot for emp.var.rate
p15 <- ggplot(bank_marketing_data) + geom_histogram(aes(bank_marketing_data$emp.var.rate),
                                                    binwidth = 0.2, fill = "palegreen3") + xlab ("Employment Variation Rate")
p15

#plot for cons.pric.index
p16 <- ggplot(bank_marketing_data) + geom_histogram(aes(bank_marketing_data$cons.price.idx),
                                                    binwidth = 0.1, fill = "palegreen3") + xlab ("Consumer Price Index")
p16

#plot for cons.conf.index
p17 <- ggplot(bank_marketing_data) + geom_histogram(aes(bank_marketing_data$cons.conf.idx),
                                                    binwidth = 0.5, fill = "palegreen3") + xlab ("Consumer Confidence Index")
p17

#plot for euribor3m
p18 <- ggplot(bank_marketing_data) + geom_histogram(aes(bank_marketing_data$euribor3m),
                                                    binwidth = 0.5, fill = "palegreen3") + xlab ("Euribor 3 months")
p18

#plot for nr.employed
p19 <- ggplot(bank_marketing_data) + geom_histogram(aes(bank_marketing_data$nr.employed),
                                                    binwidth = 10, fill = "palegreen3") + xlab ("Number of Employees")
p19

#combining the plots
forth_row_1 <- plot_grid(p19, p18, nrow = 1)
third_row_1 <- plot_grid(p17, p16, nrow = 1)
second_row_1 <- plot_grid(p15, p14, nrow = 1)
first_row_1 <- plot_grid(p13, p12, nrow = 1)
combine_plot_3 <- plot_grid(first_row_1, second_row_1, third_row_1, forth_row_1, ncol = 1)
combine_plot_3
