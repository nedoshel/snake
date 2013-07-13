#encoding: utf-8
class Snake
  attr_accessor :num,     # => исходное число
                :sqrt,    # => корень исходного числа
                :snake,   # => двумерный массив - матрица
                :start_x, # => значение X-координаты первой точки (единицы)
                :start_y, # => значение Y-координаты первой точки (единицы)
                :x_sign,  # => направление по оси Х(false => координата X следующей точки на 1 меньше предыдущей)
                :y_sign,  # => направление по оси Y(true => координата Y следующей точки на 1 больше предыдущей)
                :x,       # => текущее значение по Х
                :y        # => текущее значение по Y
  
  def initialize(num)
    @num = num   
    @sqrt = Math.sqrt(@num).to_i  
    if num > 0 && valid?        
      @snake = []
      @sqrt.times{|i| @snake[i] = []}
      initialize_default_values
      @x_sign = false
      @y_sign = true
    else
      raise ArgumentError
    end
  end

  # Проверка исходного числа на валидность
  # * *Args*    :
  # * *Returns* :
  #   true | false
  def valid?
    (sqrt * sqrt).to_i == num
  end

  # Смена направления движения змейки по осям
  def change_direction
    @x_sign = !x_sign
    @y_sign = !x_sign
  end

  # Печать результата
  def humanize_print
    max_size = num.to_s.size + 1
    snake.each_with_index do |row, i|
      print i == 0 ? "Output: " : " " * 8
      row.each do |r|
        printf "%#{max_size}d", r
      end
      print "\n"
    end
  end

  # Строит матрицу
  def build
    # первые 3 элемента матрицы
    snake[start_y][start_x] = 1
    snake[start_y][start_x + 1] = 2
    snake[start_y - 1][start_x + 1] = 3

    # текущие координаты 
    @x = start_x + 1
    @y = start_y - 1

    current_element = 4; i = 2    
    while i <= sqrt
      current_element = build_line(i, current_element, "x")
      current_element = build_line(i, current_element, "y")
      change_direction
      i += 1
    end
  end

  private
   # Строит строку или столбец в матрице
  def build_line i, current_element, direction
    j = 0
    while j < i && current_element < num
      value = eval("#{direction.to_s}_sign") ? self.send("#{direction}") + 1 : self.send("#{direction}") - 1
      self.send("#{direction}=", value)        
      snake[y][x] = current_element
      current_element += 1
      j += 1
    end
    current_element
  end

  # Иницилизация начальных значений(координаты единицы и последний элемент матрицы)
  def initialize_default_values
    if num.even? # четное
      # координаты начала змейки(единицы)
      @start_y = sqrt/2
      @start_x = start_y - 1
      @snake[0][0] = num # последнее значение всегда 0,0
    else
      # координаты начала змейки(единицы)
      @start_x = @start_y = sqrt/2
      @snake[sqrt-1][sqrt-1] = num # последнее значение всегда NxN
    end
  end
end

begin 
  print "Input: "
  val = gets.to_i
  spiral = Snake.new(val)  
  if spiral.sqrt == 1
    puts "Output: 1"
    exit 
  end
  spiral.build
  spiral.humanize_print
rescue ArgumentError, Math::DomainError
  puts "Error: #{val} is not a perfect square"
  exit
end

exit 0
