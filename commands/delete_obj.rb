require_relative '../databases/postgresql'

module Commands
  class  DeleteRecord
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
        query: "DELETE FORM #{@table} WHERE id = $1 RETURNING id",
        params: [@id]
      )
      puts "Запись успешно удалена." if result.ntuples.positive?
    end
  end
end
