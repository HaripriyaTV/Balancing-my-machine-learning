#data cleaning

#missing value treatment

#replacing the blanks with NA
is.na(bank_marketing_data) <- bank_marketing_data == ''

#visualizing the missing values
mv_plot <- aggr(bank_marketing_data, col=c('steelblue','khaki2'), numbers=TRUE, prop=FALSE,
                sortVars=TRUE, labels=names(bank_marketing_data), cex.axis=0.7, gap=1,
                varheight = FALSE,combined = FALSE,cex.numbers =0.5, 
                ylab=c("Histogram of missing data","Pattern"))

#imputation by mice
#converting the variables into factors
bank_marketing_data <- bank_marketing_data %>%
  mutate(
    job = as.factor(job),
    marital = as.factor(marital),
    education = as.factor(education),
    housing = as.factor(housing)
  )

init = mice(bank_marketing_data, maxit=0) 
meth = init$method
predM = init$predictorMatrix

#specifying the suitable methods for each variable
meth[c("loan")]="logreg" 
meth[c("job", "marital", "education")]="polyreg"

#running multiple imputation
imputed_data = mice(bank_marketing_data, method=meth, predictorMatrix=predM, m=5)
imputed_data <- complete(imputed_data)
colSums(is.na(imputed_data))

#replacing the na's in default and loan as unknown
imputed_data$default[is.na(imputed_data$default)] <- "unknown"
imputed_data$loan[is.na(imputed_data$loan)] <- "unknown"
colSums(is.na(imputed_data))
