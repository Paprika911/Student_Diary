CREATE TABLE semesters(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	CHECK (start_date < end_date)
);

CREATE TABLE students (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	age INT CHECK (age > 0)
);

CREATE TABLE student_semesters(
	student_id INT REFERENCES students(id) ON DELETE CASCADE,
	semester_id INT REFERENCES semesters(id) ON DELETE CASCADE,
	PRIMARY KEY (student_id, semester_id)
);