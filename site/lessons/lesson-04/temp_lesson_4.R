

# task 1 ----------------------------------------------------------------------------------------------------------



site_name <- "Shymbulak"
# site_name <- "Ile-Alatau"

observation_year <- 2025
latitude <- 52.45687
longitude <- 125.84480
num_species <- 7


print(site_name)
print(num_species)
site_name
num_species

class(site_name)



# task 2 ----------------------------------------------------------------------------------------------------------

site_locations <- c("Медеу", "Шымбулак", "БАО", "Тургень", "Чарын")

print(site_locations)

length(site_locations)


# 1 element
print(site_locations[1])

# 1-3 elements
print(site_locations[1:3])

# 1, 4 elements
print(site_locations[c(1, 4)])


# all but 1 and 4
print(site_locations[-c(1, 4)])



# task 3 ----------------------------------------------------------------------------------------------------------

altitudes <- c(1691, 2260, 2511, 990, 1090)

length(altitudes)

# ❓ Как проверить, что длины векторов совпадают?
length(site_locations) == length(altitudes)


# task 4 ----------------------------------------------------------------------------------------------------------

observed_species <- list(
  c("Тянь-шаньская ель", "Снежный барс", "Архар"),        
  c("Тянь-шаньская ель", "Марал", "Беркут"),         
  c("Тянь-шаньская ель", "Тянь-шаньский бурый медведь"),  
  c("Туркестанская рысь", "Саксаул", "Карагач"),   
  c("Ясень согдийский", "Туранга", "Саксаул")    
)
print(observed_species)


class(observed_species)


# task 5 ----------------------------------------------------------------------------------------------------------


# список видов для 2 объекта

observed_species[[2]]

# первый встреченный вид для 2 объекта

observed_species[[2]][1]


# task 5 * --------------------------------------------------------------------------------------------------------


# вывести список видов для "БАО" 

index <- which(site_locations == "БАО")

observed_species[[index]]

# task 6 -------

temperatures <- c(18, 15.0, 12, 25.5, 30.15) # Примерные температуры
print(temperatures)



# task 7 ----------------------------------------------------------------------------------------------------------

site_locations
temperatures

max_temp_index <- which.max(temperatures) # Индекс максимальной температуры
site_locations[max_temp_index] # Название локации по индексу


# task 8 & 9----------------------------------------------------------------------------------------------------------

altitudes

high_altitude <- (altitudes >= 2000)

high_altitude

site_locations[high_altitude]

sum(high_altitude)

# task 14 --------------------------

biodiversity_data <- data.frame(
  location = site_locations,
  altitude = altitudes,
  temperature = temperatures,
  high_altitude = high_altitude
)

biodiversity_data[1]

biodiversity_data$location

min(biodiversity_data[3])

min(biodiversity_data$temperature)

colnames(biodiversity_data)
biodiversity_data$altitude
rownames(biodiversity_data)


# task 16 ---------------------------------------------------------------------------------------------------------

biodiversity_data

biodiversity_data$altitude >= 1500

biodiversity_data$temperature >= 18

# biodiversity_data[СТРОКА,СТОЛБЕЦ]
biodiversity_data[1, ]

biodiversity_data[5, ]

biodiversity_data[, 2]

biodiversity_data[2, 2]





high_cold_locations <- biodiversity_data[biodiversity_data$altitude >= 1500 
                                        & biodiversity_data$temperature >= 18, ]


high_cold_locations







iris
colnames(iris)
