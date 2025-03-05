CREATE TABLE semesters(
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  start_date DATE,
  end_date DATE,
  grade NUMERIC
);

CREATE TABLE disciplines(
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  semester_id INTEGER,
  grade NUMERIC,
  FOREIGN KEY (semester_id) REFERENCES semesters (id) ON DELETE CASCADE
);

CREATE TABLE lab_works(
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  deadline DATE NOT NULL,
  status BOOLEAN NOT NULL DEFAULT FALSE, 
  grade INTEGER CHECK (grade BETWEEN 0 and 10),
  discipline_id INTEGER,
  FOREIGN KEY (discipline_id) REFERENCES disciplines (id) ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION update_status_on_grade_change()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.grade IS NOT NULL THEN
    NEW.status := TRUE;
  ELSE
    NEW.status := FALSE;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_status
BEFORE INSERT OR UPDATE ON lab_works
FOR EACH ROW
EXECUTE FUNCTION update_status_on_grade_change();

CREATE OR REPLACE FUNCTION update_discipline_grade()
RETURNS TRIGGER AS $$
BEGIN 
  UPDATE disciplines
  SET grade = (
    SELECT COALESCE(ROUND(AVG(grade), 2), 0) 
    FROM lab_works 
    WHERE discipline_id = NEW.discipline_id
  )
  WHERE id = NEW.discipline_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_discipline_grade
AFTER INSERT OR UPDATE OR DELETE ON lab_works
FOR EACH ROW
EXECUTE FUNCTION update_discipline_grade();

CREATE OR REPLACE FUNCTION update_semester_grade()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE semesters
	SET grade = (
	 	SELECT COALESCE(ROUND(AVG(grade), 2), 0)
	 	FROM disciplines
	 	WHERE semester_id = NEW.semester_id
	)
	WHERE id = NEW.semester_id;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_semseter_grade
AFTER INSERT OR DELETE ON disciplines
FOR EACH ROW
EXECUTE FUNCTION update_semester_grade();
