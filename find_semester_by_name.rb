require_relative 'database'

class FindSemesterByName
  def initialize(db:, semester_name:)
    @db = db
    @semester_name = semester_name
  end

  def call
    result = @db.exec_params(
      query: 'SELECT id FROM semesters WHERE name = $1',
      params: [@semester_name]
    )
    result.ntuples.positive? ? result[0]['id'] : nil
  end
end
