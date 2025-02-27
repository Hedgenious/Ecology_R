# Проверяем текущую рабочую директорию
getwd()  # Проверим текущую рабочую директорию
list.dirs()  # Смотрим все директории в рабочем каталоге

# Переходим в нужную папку для работы с архивами
message("Переход в папку с архивами...")
setwd("E:/R/Ecology_R/data/gbif/")  # Переходим в папку с архивами
list.files()  # Проверяем файлы в директории

# Загружаем список zip-файлов
zip_files <- list.files(pattern = "\\.zip$", full.names = TRUE)

# Распаковываем каждый архив в соответствующую папку с обработкой ошибок
for (file in zip_files) {
  # Получаем список файлов внутри архива
  files_in_zip <- unzip(file, list = TRUE)$Name
  
  # Создаем папку для каждого архива
  folder_name <- sub("\\.zip$", "", basename(file))  # Убираем расширение .zip из имени
  folder_path <- file.path(output_dir, folder_name)  # Путь к папке для распаковки
  
  if (!dir.exists(folder_path)) {
    dir.create(folder_path)
    message(paste("Создана папка для архива:", folder_path))
  }
  
  # Распаковываем каждый файл по очереди
  for (file_in_zip in files_in_zip) {
    message(paste("Распаковка файла:", file_in_zip))
    
    tryCatch({
      unzip(file, files = file_in_zip, exdir = folder_path)
      message(paste("Распакован:", file_in_zip, "в папку:", folder_path))
    }, error = function(e) {
      message(paste("Ошибка при распаковке файла", file_in_zip, ":", e$message))
    })
  }
}

# Сообщение о завершении распаковки
message("✅ Все файлы успешно распакованы в папку ", output_dir)



# Получаем список всех папок внутри `unzipped_data`
message("Получаем список папок внутри распакованной директории...")
unzipped_folders <- list.dirs(output_dir, full.names = TRUE, recursive = FALSE)

# Создаём список файлов в каждой папке
message("Составляем список файлов в каждой папке...")
file_list <- lapply(unzipped_folders, function(folder) {
  files <- list.files(folder, full.names = TRUE)  # Список файлов в папке
  if (length(files) > 0) {  # Если в папке есть файлы
    return(data.frame(Папка = basename(folder), Файл = files, stringsAsFactors = FALSE))
  } else {
    message(paste("Папка", folder, "пустая."))
    return(NULL)  # Если папка пуста, пропускаем её
  }
})

# Убираем пустые элементы из списка
file_list <- file_list[!sapply(file_list, is.null)]

# Объединяем результаты в одну таблицу
message("Объединяем все файлы в одну таблицу...")
file_df <- do.call(rbind, file_list)

# Отображаем результат в консоли
message("Отображение списка файлов...")
print(file_df)













# Цикл для открытия каждой папки и чтения файла occurrence.txt
for (folder in unzipped_folders) {
  # Путь к файлу occurrence.txt в текущей папке
  occurrence_file <- file.path(folder, "occurrence.txt")
  
  # Проверяем, существует ли файл occurrence.txt
  if (file.exists(occurrence_file)) {
    message(paste("Чтение файла:", occurrence_file))
    
    # Пробуем читать файл с дополнительной настройкой для разных форматов
    tryCatch({
      # Пробуем с параметром fill = TRUE, чтобы обработать строки с разным количеством столбцов
      occurrence_data <- read.table(occurrence_file, header = TRUE, sep = "\t", fill = TRUE)  # Используем табуляцию как разделитель
      message(paste("Данные из", occurrence_file, "успешно загружены"))
      
      # Пример обработки данных - вывод первых строк
      print(head(occurrence_data))
      
      # Сохраняем данные в формате RDS
      rds_file <- file.path(folder, "occurrence_data.rds")  # Путь к файлу RDS в той же папке
      saveRDS(occurrence_data, file = rds_file)
      message(paste("Данные сохранены в файл:", rds_file))
      
    }, error = function(e) {
      message(paste("Ошибка при чтении файла", occurrence_file, ":", e$message))
    })
    
  } else {
    message(paste("Файл occurrence.txt не найден в папке:", folder))
  }
}


