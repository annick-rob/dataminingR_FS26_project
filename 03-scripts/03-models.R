library(readr)
library(dplyr)
library(ggplot2)
library(broom)

meps_productivity <- read_csv("02-data_preprocessed/meps_productivity.csv")

#regression Model 
model <- lm(
  productivity ~ gender + political_group + country + term,
  data = meps_productivity
)

summary(model)

#fe country and party
model_fe <- lm(
  productivity ~ gender + term + factor(political_group) + factor(country),
  data = meps_productivity
)

summary(model_fe)

#Productivity across Gender
plot_gender <- ggplot(meps_productivity, aes(x = factor(gender), y = productivity)) +
  geom_boxplot() +
  labs(
    x = "Gender (0 = Female, 1 = Male)",
    y = "Number of Speeches",
    title = "Parliamentary Productivity by Gender"
  ) +
  theme_bw()

ggsave(
  "05-plots/productivity_gender.png",
  plot = plot_gender,
  width = 8,
  height = 6
)


# Productivity across Political Groups
plot_groups <- ggplot(meps_productivity, aes(x = political_group, y = productivity)) +
  geom_boxplot() +
  labs(
    x = "Political Group",
    y = "Number of Speeches",
    title = "Parliamentary Productivity by Political Group"
  ) +
  theme_bw()

ggsave(
  "05-plots/productivity_groups.png",
  plot = plot_groups,
  width = 8,
  height = 6
)

# Productivity across Parliamentary Terms
plot_terms <- meps_productivity |>
  dplyr::filter(term != 8) |>
  ggplot(aes(x = term, y = productivity)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm") +
  labs(
    x = "Parliamentary Term",
    y = "Number of Speeches",
    title = "Parliamentary Productivity Across Terms"
  ) +
  theme_bw()

ggsave(
  "05-plots/productivity_term.png",
  plot = plot_terms,
  width = 8,
  height = 6
)

# coef plot
coefplot <- tidy(model_fe) |> 
  ggplot(aes(x = estimate, y = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = estimate - 1.96 * std.error,
                     xmax = estimate + 1.96 * std.error)) +
  labs(
    x = "Coefficient Estimate",
    y = "",
    title = "Regression Coefficients"
  ) +
  theme_bw()

ggsave(
  "05-plots/coefplot.png",
  plot = coefplot,
  width = 8,
  height = 6
)

