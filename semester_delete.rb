require_relative 'database'

module Command
  class DeleteSemester
    def initialize
      @db = Database.new
    end

    def call
      input_name

      delete_semester

      puts 'Семестр был успешно удален.' if @result.ntuples.positive?
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

      @semester_id = FindSemesterByName.new(db: @db, semester_name: @semester_name).call

      return puts "Семестр с именем #{@semester_name} не найден." if @semester_id.nil?

      true
    end

    def delete_semester
      @result = @db.exec_params(
        query: 'DELETE FROM semesters WHERE id = $1 RETURNING name',
        params: [@semester_id]
      )
    end
  end
end
