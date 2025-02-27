class LabWork
  attr_accessor :id, :lab_work_name, :deadline, :status, :grade, :discipline_id 

  def initialize(id:, lab_work_name:, deadline:, status:, grade:, discipline_id:)
    @id = id
    @lab_work_name = lab_work_name
    @deadline = deadline
    @status = status
    @grade = grade
    @discipline_id = discipline_id 
  end
end
