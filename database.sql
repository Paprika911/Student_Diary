CREATE TABLE semesters(
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  start_date DATE,
  end_date DATE
);

CREATE TABLE disciplines(
  id SERIAL PRIMARY KEY, 
  name VARCHAR(100),
  semester_id INTEGER NOT NULL, 
  semester_id INTEGER NOT NULL REFERENCES semesters(id) ON DELETE CASCADE
);
