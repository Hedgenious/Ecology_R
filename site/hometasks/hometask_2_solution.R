### Задание 1: Работа с последовательностью

# Создаём числовую последовательность
numbers <- sort(c(seq(0, 245, by = 5), seq(1, 246, by = 5)))

# Выводим результат в консоль
print(numbers)

# Проверяем тип данных
print(class(numbers))
class(numbers)

# Умножаем каждый элемент вектора на 3
numbers_multiplied <- numbers * 3
print(numbers_multiplied)

# Находим сумму всех элементов нового вектора
sum_numbers <- sum(numbers_multiplied)
print(sum_numbers)

### Задание 2: Работа с двумя последовательностями и вычислением средних значений

# Создаём два числовых вектора
vector_a <- seq(1, 199, by = 2) # Нечётные числа
vector_b <- seq(2, 200, by = 2) # Чётные числа

# Покомпонентное сложение векторов
vector_sum <- vector_a + vector_b
print(vector_sum)

# Рассчитываем средние значения
mean_a <- mean(vector_a)
mean_b <- mean(vector_b)
mean_sum <- mean(vector_sum)

print(mean_a)
print(mean_b)
print(mean_sum)

### Задание 3: Создание и работа с data.frame

# Создаём data.frame
TABLE <- data.frame(
  numbers = numbers,
  vector_a = vector_a,
  vector_b = vector_b,
  vector_sum = vector_sum
)

# Просмотр первых и последних строк
print(head(TABLE))
print(tail(TABLE, n = 10))

# Находим минимальные и максимальные значения в каждом столбце
min_numbers <- min(TABLE$numbers)
max_numbers <- max(TABLE$numbers)

min_a <- min(TABLE$vector_a)
max_a <- max(TABLE$vector_a)

min_b <- min(TABLE$vector_b)
max_b <- max(TABLE$vector_b)

min_sum <- min(TABLE$vector_sum)
max_sum <- max(TABLE$vector_sum)

print(c(min_numbers, max_numbers))
print(c(min_a, max_a))
print(c(min_b, max_b))
print(c(min_sum, max_sum))

# Рассчитываем средние значения для каждого столбца
mean_numbers <- mean(TABLE$numbers)
mean_a <- mean(TABLE$vector_a)
mean_b <- mean(TABLE$vector_b)
mean_sum <- mean(TABLE$vector_sum)

print(mean_numbers)
print(mean_a)
print(mean_b)
print(mean_sum)

# Считаем сумму средних значений
total_mean <- mean_numbers + mean_a + mean_b + mean_sum
print(total_mean)


