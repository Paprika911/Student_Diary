require_relative '../databases/postgresql'

module Commands
  class DeleteRecord
    def initialize(table:, id:)
      @table = table
      @id = id
    end

    def call
      delete_record
    end

    private

    def delete_record
      result = Databases::Postgresql.perform_query(
        query: "DELETE FROM #{@table} WHERE id = $1 RETURNING id",
        params: [@id]
      )

      return puts 'Запись успешно удалена.' if result.ntuples.positive?

      puts "Не найдена запись в #{@table} с id #{@id}."
    rescue PG::UndefinedTable
      puts "Ошибка: таблица #{@table} не найдена."
    end
  end
end
