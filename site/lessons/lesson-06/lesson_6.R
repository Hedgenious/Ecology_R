# library
library(ggplot2)

?rnorm
set.seed(123)
rnorm(100, mean = 3, sd = 2)
# dataset:
data <- data.frame(value = rnorm(100, mean = 3, sd = 2))

# basic histogram
plot <- ggplot(data, aes(x = value)) + 
  geom_histogram()
plot

plot <- ggplot(aes(x = data$value)) + 
  geom_histogram()
plot

plot(data)

hist(data$value)


ggplot(data, aes(x = value)) +
  geom_histogram()

ggplot(data = data) +
  geom_histogram(mapping = aes(value))


rnorm(100, mean = 3, sd = 1)

rnorm(100, 3, 1)

library(tidyverse)
mpg %>% colnames()

c <- ggplot(mpg, aes(hwy))

c + geom_histogram(bins = 8)

c + geom_histogram(binwidth = 5, 
                   color = "black", 
                   fill = "grey80") +
  theme_bw()

"red"
"green"
"blue"
"darkgreen"
"darkblue"
"yellow"
'magenta'
"white"
"black"


"grey"
"grey90"
"grey10"
"grey50"
"grey1"
"grey99"
"green1" == "green"
"green2"
"green3"
"green4"

"#050488"
"#FFFFFF"
"#000000"
"#FF0000"




ggplot(mpg, aes(cty, hwy)) +
  geom_point(
    alpha = 0.3,
    color = "black", 
    fill = "grey50",
    shape = 21,
    size = 3
  ) +
  geom_rug()
  # geom_smooth() +
  # geom_quantile()
  


# city miles per gallon
# highway miles per gallon

ggplot(mpg, aes(class, hwy)) +
  geom_boxplot(
    fill = "gold"
  ) +
  labs(
    x = "Класс автомобиля",
    y = "Расход за городом",
    title = "Расход топлива среди разных классов автомобилей",
    subtitle = "Измерения проведены на шоссе"
  ) + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(plot.subtitle = element_text(hjust = 0.5))



plot2 <- ggplot(mpg, aes(class, hwy)) +
  geom_boxplot(
    fill = "blue",
    alpha = 0.3
  ) +
  geom_violin(
    fill = "gold"
  ) +
  labs(
    x = "Класс автомобиля",
    y = "Расход за городом",
    title = "Расход топлива среди разных классов автомобилей",
    subtitle = "Измерения проведены на шоссе"
  ) + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(plot.subtitle = element_text(hjust = 0.5))

ggsave("plot2.png", plot = plot2, width = 5, height = 3.5)

ggsave("plot3.png", plot = plot2, width = 10, height = 2)



# -----------------------------------------------------------------------------------------------------------------

# install.packages("ggpattern")

library(ggpattern)
  
ggplot(mpg, aes(class)) +
  geom_bar_pattern(
    aes(
      pattern = class, 
      pattern_angle = class
    ), 
    fill            = 'grey80', 
    colour          = 'black',
    pattern_spacing = 0.05
  ) +
  theme_bw(18) +
  labs(title = "ggpattern::geom_bar_pattern()") + 
  theme(legend.position = 'none') +
  coord_fixed(ratio = 1/15) + 
  scale_pattern_discrete(guide = guide_legend(nrow = 1))



