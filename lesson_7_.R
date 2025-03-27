

DIR <- setwd("E:/R/Ecology_R/data/gbif/unzipped_data/")

DIR_LIST <- list.dirs(DIR, full.names = TRUE, recursive = FALSE)
DIR_LIST


for (WORK_DIR in DIR_LIST) {
  Function_DIR_CYCLE(WORK_DIR)
}

Function_DIR_CYCLE <- function(WORK_DIR) {

# ============================================================
# 🟢 ЭТАП 1: УСТАНОВКА И ЗАГРУЗКА ПАКЕТОВ [2025-03-27]
# ============================================================
cat("\n🟢 [2025-03-27] ЭТАП 1: Установка и загрузка пакетов...\n")


if (!requireNamespace("tibble", quietly = TRUE)) install.packages("tibble")
if (!requireNamespace("readr", quietly = TRUE)) install.packages("readr")
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("tidyr", quietly = TRUE)) install.packages("tidyr")
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
if (!requireNamespace("rnaturalearth", quietly = TRUE)) install.packages("rnaturalearth")
if (!requireNamespace("rnaturalearthdata", quietly = TRUE)) install.packages("rnaturalearthdata")
if (!requireNamespace("sf", quietly = TRUE)) install.packages("sf")

library(tibble)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)
library(sf)


# ============================================================
# 🟢 ЭТАП 2: УСТАНОВКА РАБОЧЕЙ ДИРЕКТОРИИ [2025-03-27]
# ============================================================
cat("\n🟢 [2025-03-27] ЭТАП 2: Установка рабочей директории...\n")

# Укажите при необходимости другой путь


getwd()

# ============================================================
# 🟢 ЭТАП 3: ЗАГРУЗКА ДАННЫХ И ПРЕОБРАЗОВАНИЕ [2025-03-27]
# ============================================================
cat("\n🟢 [2025-03-27] ЭТАП 3: Загрузка RDS-файла, преобразование в tibble, фильтрация...\n")

# Загрузка RDS файла с данными наблюдений и преобразование в tibble
setwd(WORK_DIR)
occurrence_data <- readRDS("occurrence_data.rds")
occurrence_tbl <- as_tibble(occurrence_data)
occurrence_tbl %>% colnames()

# Подвыборка ключевых столбцов с детальной информацией
observations_subset <- occurrence_tbl %>%
  select(
    eventDate,
    year,
    month,
    day,
    
    eventTime,
    
    decimalLatitude, # широта
    decimalLongitude, # долгота
    
    coordinateUncertaintyInMeters,
    
    genus,
    specificEpithet,
    scientificName,
    
    speciesKey
  )

# Преобразуем eventDate в формат Date, добавляем столбец weekday
observations_subset <- observations_subset %>%
  mutate(
    eventDate = as.Date(eventDate, format = "%Y-%m-%d"),
    weekday   = weekdays(eventDate)
  )

observations_subset$weekday
# ============================================================
# 🟢 ЭТАП 4: РАСЧЁТ СТАТИСТИК [2025-03-27]
# ============================================================
cat("\n🟢 [2025-03-27] ЭТАП 4: Расчёт статистических сводок...\n")

# 1. Статистика по количеству наблюдений для каждого вида
species_count <- observations_subset %>%
  group_by(scientificName) %>%
  summarise(observation_count = n()) %>%
  arrange(desc(observation_count))
cat("\nСтатистика по количеству наблюдений для каждого вида:\n")
print(species_count)

# 2. Статистика по годам
year_summary <- observations_subset %>%
  group_by(year) %>%
  summarise(observation_count = n()) %>%
  arrange(year)
cat("\nСтатистика по годам (количество наблюдений):\n")
print(year_summary, n = 100)

# 3. Статистика по месяцам
month_summary <- observations_subset %>%
  group_by(month) %>%
  summarise(observation_count = n()) %>%
  arrange(month)
cat("\nСтатистика по месяцам (количество наблюдений):\n")
print(month_summary)

# 4. Статистика по координатам
coordinates_stats <- observations_subset %>%
  summarise(
    min_latitude  = min(decimalLatitude, na.rm = TRUE),
    max_latitude  = max(decimalLatitude, na.rm = TRUE),
    min_longitude = min(decimalLongitude, na.rm = TRUE),
    max_longitude = max(decimalLongitude, na.rm = TRUE)
  )
cat("\nСтатистика по координатам:\n")
print(coordinates_stats)

# 5. Количество наблюдений с координатами
observations_with_coords <- observations_subset %>%
  filter(!is.na(decimalLatitude) & !is.na(decimalLongitude)) %>%
  nrow()
total_obs <- nrow(observations_subset)
cat("\nКоличество наблюдений с координатами:", observations_with_coords, "\n")
cat("Процент наблюдений с координатами:", round((observations_with_coords / total_obs) * 100, 3), "%\n")

# 6. Статистика по родам
genus_summary <- observations_subset %>%
  group_by(genus) %>%
  summarise(observation_count = n()) %>%
  arrange(desc(observation_count))
cat("\nСтатистика по родам:\n")
print(genus_summary)

# 7. Статистика по точности координат
coordinate_uncertainty_stats <- observations_subset %>%
  summarise(
    mean_uncertainty   = mean(coordinateUncertaintyInMeters, na.rm = TRUE),
    median_uncertainty = median(coordinateUncertaintyInMeters, na.rm = TRUE),
    sd_uncertainty     = sd(coordinateUncertaintyInMeters, na.rm = TRUE)
  )
cat("\nСтатистика по точности координат (coordinateUncertaintyInMeters):\n")
print(coordinate_uncertainty_stats)

observations_subset$coordinateUncertaintyInMeters %>% summary()
observations_subset$coordinateUncertaintyInMeters %>% length()

# 8. Статистика по региону (stateProvince), если данные заполнены
if ("stateProvince" %in% colnames(occurrence_tbl)) {
  state_summary <- occurrence_tbl %>%
    filter(!is.na(stateProvince) & stateProvince != "") %>%
    group_by(stateProvince) %>%
    summarise(observation_count = n()) %>%
    arrange(desc(observation_count))
  cat("\nСтатистика по штатам/регионам (stateProvince):\n")
  print(state_summary, n = 100)
}

# 9. Статистика по статусу наблюдений (occurrenceStatus)
if ("occurrenceStatus" %in% colnames(occurrence_tbl)) {
  occurrence_status_summary <- occurrence_tbl %>%
    group_by(occurrenceStatus) %>%
    summarise(observation_count = n()) %>%
    arrange(desc(observation_count))
  cat("\nСтатистика по статусу наблюдений (occurrenceStatus):\n")
  print(occurrence_status_summary)
}

# 10. Распределение наблюдений по дням недели
weekday_summary <- observations_subset %>%
  group_by(weekday) %>%
  summarise(observation_count = n()) %>%
  arrange(weekday)
cat("\nСтатистика по дням недели (eventDate):\n")
print(weekday_summary)

# 11. Количество уникальных видов
unique_species <- observations_subset %>%
  distinct(scientificName) %>%
  nrow()
cat("\nКоличество уникальных видов:", unique_species, "\n")


# ============================================================
# 🟢 ЭТАП 5: ПОСТРОЕНИЕ ГРАФИКОВ (НАУЧНЫЙ СТИЛЬ) [2025-03-27]
# ============================================================
cat("\n🟢 [2025-03-27] ЭТАП 5: Построение графиков...\n")

# 1. Топ-10 видов
top_species <- species_count %>% top_n(10, observation_count)
ggplot(top_species, aes(x = reorder(scientificName, observation_count), y = observation_count)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(title = "Топ 10 видов по количеству наблюдений", x = "Научное название", y = "Количество наблюдений") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

# 2. Количество наблюдений по годам
ggplot(year_summary, aes(x = as.factor(year), y = observation_count)) +
  geom_bar(stat = "identity", fill = "tomato") +
  labs(title = "Количество наблюдений по годам", x = "Год", y = "Количество наблюдений") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))


month_summary  <-  month_summary %>% 
  filter(is.na(month) != TRUE)

# 3. Количество наблюдений по месяцам
ggplot(month_summary, aes(x = as.factor(month), y = observation_count)) +
  geom_bar(stat = "identity", 
           fill = "forestgreen") +
  labs(title = "Количество наблюдений по месяцам", 
       x = "Месяц", 
       y = "Количество наблюдений") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))




# 4. Географическое распределение наблюдений (точки)
observations_coords <- observations_subset %>% filter(!is.na(decimalLatitude) & !is.na(decimalLongitude))
ggplot(observations_coords, aes(x = decimalLongitude, y = decimalLatitude)) +
  geom_point(alpha = 0.5, color = "purple") +
  labs(title = "Распределение наблюдений по координатам", x = "Долгота", y = "Широта") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

# 5. Топ-10 родов
top_genus <- genus_summary %>% top_n(10, observation_count)
ggplot(top_genus, aes(x = reorder(genus, observation_count), y = observation_count)) +
  geom_bar(stat = "identity", fill = "orange") +
  coord_flip() +
  labs(title = "Топ 10 родов по количеству наблюдений", x = "Род", y = "Количество наблюдений") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

# 6. Гистограмма распределения точности координат
ggplot(observations_subset, aes(x = coordinateUncertaintyInMeters)) +
  geom_histogram(binwidth = 100, fill = "cyan", color = "black") +
  labs(title = "Распределение точности координат", x = "Неопределенность координат (м)", y = "Количество наблюдений") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

# 7. Наблюдения по штатам/регионам (если данные присутствуют)
if (exists("state_summary")) {
  ggplot(state_summary, aes(x = reorder(stateProvince, observation_count), y = observation_count)) +
    geom_bar(stat = "identity", fill = "skyblue") +
    coord_flip() +
    labs(title = "Количество наблюдений по штатам/регионам", x = "Штат/Регион", y = "Количество наблюдений") +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5))
}

# 8. Статус наблюдений (если данные присутствуют)
if (exists("occurrence_status_summary")) {
  ggplot(occurrence_status_summary, aes(x = reorder(occurrenceStatus, observation_count), y = observation_count)) +
    geom_bar(stat = "identity", fill = "pink") +
    coord_flip() +
    labs(title = "Статус наблюдений", x = "Статус", y = "Количество наблюдений") +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5))
}

# 9. Наблюдения по дням недели
ggplot(weekday_summary, aes(x = weekday, y = observation_count)) +
  geom_bar(stat = "identity", fill = "magenta") +
  labs(title = "Количество наблюдений по дням недели", x = "День недели", y = "Количество наблюдений") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))


# ============================================================
# 🟢 ЭТАП 6: ПОСТРОЕНИЕ КАРТЫ НАБЛЮДЕНИЙ [2025-03-27]
# ============================================================
cat("\n🟢 [2025-03-27] ЭТАП 6: Построение качественной карты наблюдений в Казахстане...\n")

# Загрузка полигона Казахстана
kazakhstan <- ne_countries(country = "Kazakhstan", scale = "medium", returnclass = "sf")

# Получаем границы (bounding box) Казахстана
kaz_bbox <- st_bbox(kazakhstan)

# Строим карту, гарантируя, что весь контур Казахстана виден
ggplot() +
  geom_sf(data = kazakhstan, fill = "lightblue", color = "black") +
  geom_point(
    data = observations_coords,
    aes(x = decimalLongitude, y = decimalLatitude),
    color = "red3", alpha = 0.6, size = 1.5
  ) +
  labs(title = "Карта наблюдений в Казахстане", x = "Долгота", y = "Широта") +
  coord_sf(
    xlim = c(kaz_bbox$xmin, kaz_bbox$xmax),
    ylim = c(kaz_bbox$ymin, kaz_bbox$ymax),
    expand = FALSE
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))


# ============================================================
# ✅ ЗАВЕРШЕНИЕ СКРИПТА [2025-03-27]
# ============================================================
cat("\n✅ [2025-03-27] Скрипт успешно завершён.\n")

}



