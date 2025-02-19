require_relative '../database'
require_relative '../queries/semester_query'

module Commands
  class DeleteSemester
    def call
      input_name
      delete_semester
      puts 'Семестр был успешно удален.' if @result.ntuples.positive?
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

      @semester_id = Queries::SemesterQuery.new.find_by_name(semester_name: @semester_name)
      return puts "Семестр с именем #{@semester_name} не найден." if @semester_id.nil?

      true
    end

    def delete_semester
      @result = Databases::Postgresql.perform_query(
        query: 'DELETE FROM semesters WHERE id = $1 RETURNING name',
        params: [@semester_id]
      )
    end
  end
end
