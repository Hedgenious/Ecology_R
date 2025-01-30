
# install.packages("dplyr")
# install.packages("tidyverse")

install.packages("dplyr")
library("dplyr")
starwars <- starwars

starwars$birth_year

starwars$birth_year

starwars$sex

starwars$gender


# -----------------------------------------------------------------------------------------------------------------




for (i in 1:1000000) {
  
  print(paste0("Начинает выполняться цикл ", i, " ..."))
  # Sys.sleep(2)
  print(paste0("i в этом цикле равняется: ", i))
  # Sys.sleep(2)
  print(paste0("Заканчивается выполняться цикл ", i, "."))
  # Sys.sleep(2)
  
}


weekdays <- c("Понедельник", 
              "Вторник", 
              "Среда", 
              "Четверг", 
              "Пятница", 
              "Суббота", 
              "Воскресенье")

for (day in weekdays[1:5]) {
  
  print(paste0("Начинается ", day, " =)"))
  Sys.sleep(2)
  # print(paste0("i в этом цикле равняется: ", i))
  # Sys.sleep(2)
  print(paste0("Заканчивается ", day, " =("))
  Sys.sleep(2)
  
}



starwars

colnames(starwars)

for (i in 1:length(starwars$name)) {
  
  print(paste0("Персонаж ", 
               starwars$name[i], 
               " родился на планете ", 
               starwars$homeworld[i],
               ".",
               
               " Его/её ИМТ равняется: ",
               round(starwars$mass[i] / ((starwars$height[i] * 0.01)^2), 1)
        )
  )
  Sys.sleep(1)
  
}


i <- 1

while (i < 11) {
  
  print(paste0("Персонаж ", 
               starwars$name[i], 
               " родился на планете ", 
               starwars$homeworld[i],
               ".",
               
               " Его/её ИМТ равняется: ",
               round(starwars$mass[i] / ((starwars$height[i] * 0.01)^2), 1)
  )
  )
  Sys.sleep(0.1)
  
  print(i)
  i <- i + 1
  
}

starwars <- starwars

for (i in 1:length(starwars$name)) {
  
  if (starwars$sex[i] %in% c("none", NA)) {
    
    print(paste("Это не человек, пропускаем расчёт ИМТ..."))
   
  } else  {
  
    print(paste0("Персонаж ", 
               starwars$name[i], 
               " родился на планете ", 
               starwars$homeworld[i],
               ".",
               
               " Его/её ИМТ равняется: ",
               round(starwars$mass[i] / ((starwars$height[i] * 0.01)^2), 1)
    )
  )
  Sys.sleep(0.1)
  }
  
}


ifelse( 3 > 2, "верно", "неверно")
