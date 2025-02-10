require_relative 'database'

module Command
  class DeleteSemester
    def initialize
      @db = Database.new
    end

    def call
      input_name

      result = @db.exec_params(
        query: 'DELETE FROM semesters WHERE name = $1 RETURNING name',
        params: [@semester_name]
      )

      puts 'Семестр был успешно удален.' if result.ntuples.positive?
    ensure
      @db.close
    end

    private

    def input_name
      loop do
        puts 'Введите название Семестра, который хотите удалить:'
        @semester_name = gets.chomp

        break if valid_name?
      end
    end

    def valid_name?
      return puts 'Название Семестра не может быть пустым' if @semester_name.nil? || @semester_name.strip.empty?

      result_again = @db.exec_params(
        query: 'SELECT * FROM semesters WHERE name = $1',
        params: [@semester_name]
      )

      return puts "Семестр с именем #{@semester_name} не найден." if result_again.ntuples.zero?

      true
    end
  end
end
