# ============================================================
# 🟢 ОСНОВНОЙ СКРИПТ: Обработка папок GBIF и генерация отчетов
# ============================================================
cat("\n🟢 [", Sys.Date(), "] ЗАПУСК ОСНОВНОГО СКРИПТА\n")

# --- 1. Настройка ---
cat("--- Этап 1: Настройка ---\n")

# Укажите путь к основной папке с подпапками данных GBIF
MAIN_DIR <- "E:/R/Ecology_R/data/gbif/unzipped_data/"
# Укажите путь к файлу шаблона R Markdown
RMD_TEMPLATE_FILE <- "E:/R/Ecology_R/lesson_7/lesson_7.Rmd" # Убедитесь, что этот файл существует

# Проверка существования основной директории
if (!dir.exists(MAIN_DIR)) {
  stop("Основная директория не найдена: ", MAIN_DIR)
}

# Проверка существования файла шаблона
if (!file.exists(RMD_TEMPLATE_FILE)) {
  stop("Файл шаблона R Markdown не найден: ", RMD_TEMPLATE_FILE)
}

# Получаем список подпапок (не рекурсивно)
DIR_LIST <- list.dirs(MAIN_DIR, full.names = TRUE, recursive = FALSE)

if (length(DIR_LIST) == 0) {
  stop("В указанной директории нет подпапок для обработки: ", MAIN_DIR)
}

cat("Найдено папок для обработки:", length(DIR_LIST), "\n")
# print(DIR_LIST) # Раскомментируйте, если нужно увидеть список папок

# --- 2. Установка и загрузка пакетов ---
cat("\n--- Этап 2: Проверка и установка пакетов ---\n")

required_packages <- c("rmarkdown", "tibble", "readr", "dplyr", "tidyr",
                       "ggplot2", "rnaturalearth", "rnaturalearthdata", "sf")

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat("Установка пакета:", pkg, "\n")
    install.packages(pkg)
  }
  # library(pkg, character.only = TRUE) # Загружать не обязательно здесь, Rmd сам загрузит
}
# Убедимся, что rmarkdown точно загружен для функции render
library(rmarkdown)
cat("Все необходимые пакеты проверены/установлены.\n")


# --- 3. Цикл обработки папок и генерации отчетов ---
cat("\n--- Этап 3: Обработка папок и генерация отчетов ---\n")

for (WORK_DIR in DIR_LIST) {
  cat("\n------------------------------------------------------------\n")
  cat("Начало обработки папки:", basename(WORK_DIR), "\n")
  cat("Полный путь:", WORK_DIR, "\n")
  
  # Проверяем наличие rds файла в папке
  rds_path <- file.path(WORK_DIR, "occurrence_data.rds")
  if (!file.exists(rds_path)) {
    cat("ПРЕДУПРЕЖДЕНИЕ: Файл occurrence_data.rds не найден в папке", basename(WORK_DIR), ". Пропуск папки.\n")
    next # Переходим к следующей папке
  }
  
  
  # Формируем имя выходного HTML файла
  output_filename <- paste0("report_", basename(WORK_DIR), ".html")
  output_path <- file.path(WORK_DIR, output_filename) # Сохраняем в ту же папку
  
  # Используем tryCatch для обработки ошибок во время рендеринга
  tryCatch({
    cat("Генерация отчета:", output_filename, "...\n")
    
    # Вызов рендеринга R Markdown
    rmarkdown::render(
      input = RMD_TEMPLATE_FILE,         # Путь к шаблону Rmd
      output_format = "html_document",   # Формат вывода
      output_file = output_filename,     # Имя выходного файла
      output_dir = WORK_DIR,             # Директория для сохранения отчета
      params = list(
        data_directory = WORK_DIR        # Передача параметра в Rmd
      ),
      quiet = FALSE # Установите TRUE, чтобы скрыть вывод pandoc
    )
    
    cat("✅ Отчет успешно создан для папки:", basename(WORK_DIR), "\n")
    cat("   Файл сохранен как:", output_path, "\n")
    
  }, error = function(e) {
    # Сообщение об ошибке, если рендеринг не удался
    cat("\n❌ ОШИБКА при обработке папки:", basename(WORK_DIR), "\n")
    cat("   Сообщение об ошибке:", conditionMessage(e), "\n")
  }) # Конец tryCatch
  
} # Конец цикла for

# ============================================================
# ✅ ЗАВЕРШЕНИЕ ОСНОВНОГО СКРИПТА
# ============================================================
cat("\n------------------------------------------------------------\n")
cat("✅ [", Sys.Date(), "] Основной скрипт завершил работу.\n")