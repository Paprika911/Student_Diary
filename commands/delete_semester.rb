require_relative '../databases/postgresql'
require_relative '../queries/semester_query'

module Commands
  class DeleteSemester
    def call
      input_name
      delete_semester
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

      semester = Queries::SemesterQuery.new.find_by_name(semester_name: @semester_name)
      return puts "Семестр с именем #{@semester_name} не найден." if semester.nil?

      @semester_id = semester.id
      true
    end

    def delete_semester
      Commands::DeleteRecord.new(table: 'semesters', id: @semester_id).call
    end
  end
end
