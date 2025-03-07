CREATE TABLE semesters(
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  start_date DATE,
  end_date DATE
);

CREATE TABLE disciplines(
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  semester_id INTEGER,
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
