require 'date'
require 'pg'

con = PG.connect(dbname: 'student_diary', user: 'paprika911', password: 'roma39140')
puts "Соединение установлено " if con

class Semesters 
  attr_accessor :semester_name, :start_date, :end_date

  def initialize(semester_name, start_date, end_date)
    @semester_name = semester_name
    @start_date = start_date
    @end_date = end_date
  end

  def name
    puts "Название семестра: #{semester_name}."
  end

  def date
    puts "Семестр #{semester_name} начинается #{start_date}, заканчивается #{end_date}."
  end

end 

def parse_date(input)
  begin
    Date.parse(input)
  rescue ArgumentError
    puts "Неверный формат записи даты. Необходимый формат: YYYY-MM-DD."
    nil
  end
end

def list_semesters(con)
  puts "Список Семестров:"
  result = con.exec("SELECT * FROM semesters")
  if result.ntuples.zero?
    puts "В таблице нет данных."
  else
    result.each do |row|
      puts "Название: #{row['name']}, дата начала: #{row['start_date']}, дата окончания: #{row['end_date']}."
    end
  end
end


puts "Введите 1, если хотите просмотреть список Семестров:" 
boo = gets.chomp.to_i
if boo == 1
  list_semesters(con)
end

puts "Введите 1, если хотите создать Семестр:" 
boo = gets.chomp.to_i
if boo == 1
  puts "Введите название Семестра: "
  semester_name = gets.chomp

  puts "Введите дату начала Семестра (в формате YYYY-MM-DD):"
  input = gets.chomp
  start_date = parse_date(input)

  puts "Введите дату конца Семестра (в формате YYYY-MM-DD):"
  input = gets.chomp
  end_date = parse_date(input)

  semester = Semesters.new(semester_name, start_date, end_date)
  semester.name
  semester.date

  con.exec_params("INSERT INTO semesters (name, start_date, end_date) VALUES ($1, $2, $3)", 
  [semester_name, start_date, end_date])
  list_semesters(con)
end

puts "Введите 1, если хотите удалить Семестр:"
boo = gets.chomp.to_i
if boo == 1  
  puts "Введите название Семестра, которое хотите удалить:"
  input = gets.chomp

  con.exec("DELETE FROM semesters WHERE name = $1", [input])
  list_semesters(con)
end

con.close