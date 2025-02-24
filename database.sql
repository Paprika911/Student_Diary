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
