require_relative '../databases/postgresql'
require_relative '../queries/discipline_query'

module Commands
  class DeleteDiscipline
    def initialize(semester_id:)
      @semester_id = semester_id
    end

    def call
      input_name
      delete_discipline
      puts 'Дисциплина была успешно удалена.' if @result.ntuples.positive?
    end

    private

    def input_name
      loop do
        puts 'Введите название Дисциплины, которую хотите удалить:'
        @discipline_name = gets.chomp
        break if valid_name?
      end
    end

    def valid_name?
      return puts 'Название Дисциплины не может быть пустым' if @discipline_name.nil? || @discipline_name.strip.empty?

      discipline = Queries::DisciplineQuery.new.find_by_name(discipline_name: @discipline_name)
      return puts "Дисциплина с именем #{@semester_name} не найдена." if discipline.nil?

      @discipline_id = discipline.id
      true
    end

    def delete_discipline
      @result = Databases::Postgresql.perform_query(
        query: 'DELETE FROM disciplines WHERE id = $1 AND semester_id = $2 RETURNING name',
        params: [@discipline_id, @semester_id]
      )
    end
  end
end
