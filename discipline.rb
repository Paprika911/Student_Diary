class Discipline
  attr_accessor :id, :discipline_name, :semester_id

  def initialize(id:, discipline_name:, semester_id:)
    @id = id
    @discipline_name = discipline_name
    @semester_id = semester_id
  end
end
