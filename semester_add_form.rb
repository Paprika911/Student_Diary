require_relative 'database'
require 'date'

db = Database.new

module Forms
  class SemesterForm
    attr_accessor :semester_name, :start_date, :end_date, :db

    def initialize(semester_name:, start_date:, end_date:, db:)
      @db = db
      @errors = []
    end

    def user_input
      puts 'Введите название Семестра: '
      @semester_name = gets.chomp

      puts 'Введите дату начала Семестра (в формате YYYY-MM-DD):'
      @start_date = gets.chomp

      puts 'Введите дату конца Семестра (в формате YYYY-MM-DD):'
      @end_date = gets.chomp
    end

    def processing
      return out_errors unless valid?

      semester = Semester.new(
      semester_name: @semester_name,
      start_date: @start_date,
      end_date: @end_date
    )
      save_db(semester)
    end

    private

    def valid?
      valid_semester_name
      valid_already_exist
      valid_dates
      valid_start_end

      @errors.empty?
    end

    def valid_semester_name
      @errors << 'Название Семестра не может быть пустым' if @semester_name.nil? || @semester_name.strip.empty?
    end

    def valid_already_exist
      result = @db.exec_params(
        query: 'SELECT * FROM semesters WHERE name = $1',
        params: [@semester_name]
      )
      @errors << 'Семестр с таким названием уже существует.' if result.ntuples.positive?
    end

    def valid_dates
      @start_date = parse_date(@start_date, 'начала')
      @end_date = parse_date(@end_date, 'окончания')
    end

    def parse_date(date, key)
      if date.nil? || date.strip.empty?
        @errors << "Дата #{key} должна быть заполнена."
        return nil
      end

      unless date.match?(/\A\d{4}-\d{2}-\d{2}\z/)
        @errors << "Неверный формат записи даты #{key} Семестра (необходимый формат: YYYY-MM-DD)"
        return nil
      end

      begin
        Date.parse(date)
      rescue ArgumentError
        @errors << "Неверный формат записи даты #{key} Семестра (необходимый формат: YYYY-MM-DD)"
        nil
      end
    end

    def valid_start_end
      if @start_date && @end_date
        @errors << 'Дата начала Семестра не может быть позже даты окончания' if @start_date >= @end_date
      end
    end

    def save_db(semester)
      @db.exec_params(
        query: 'INSERT INTO semesters (name, start_date, end_date) VALUES ($1, $2, $3)',
        params: [semester.semester_name, semester.start_date, semester.end_date])
      puts 'Семестр успешно добавлен!'
    end

    def out_errors
      puts 'Неверно введены данные:'
      @errors.each { |error| puts error }
    end
  end
end

puts 'Введите 1, если хотите создать Семестр:'
boo = gets.chomp.to_i
if boo == 1
  puts 'Введите название Семестра: '
  semester_name = gets.chomp

  puts 'Введите дату начала Семестра (в формате YYYY-MM-DD):'
  start_date = gets.chomp

  puts 'Введите дату конца Семестра (в формате YYYY-MM-DD):'
  end_date = gets.chomp

  form = Forms::SemesterForm.new(
    semester_name: semester_name,
    start_date: start_date,
    end_date: end_date,
    db: db
  )
  form.processing

  Semester.list_semesters(@db)
end
