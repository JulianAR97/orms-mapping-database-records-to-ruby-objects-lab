class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = <<-SQL
      SELECT * 
      FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end

  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * 
      FROM students
      WHERE name = ? 
      LIMIT 1    
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  # def self.all_students_in_grade_X(grade)
  #   sql = <<-SQL
  #     SELECT * 
  #     FROM *
  #     WHERE grade = ?
  #   SQL
    
  #   DB[:conn].execute(sql, grade).map do |row|
  #     self.new 
  # end

  def self.all_students_in_grade_9 
    self.all_students_in_grade_X(9)
  end
  
  def self.all_students_in_grade_X(grade_x)
    self.all.select {|student| student.grade == "#{grade_x}"}
  end

  def self.first_X_students_in_grade_10(num_students)
    self.all_students_in_grade_X(10)[0..num_students - 1]
  end

  def self.first_student_in_grade_10 
    self.first_X_students_in_grade_10(1)[0]
  end

  def self.students_below_12th_grade 
    #Could chain together all students_in_grade_x, but makes more sense to create another select method here 
    self.all.select {|student| student.grade != "12"}
  
  end
end
