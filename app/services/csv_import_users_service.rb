class CsvImportUsersService
  require 'csv'

  def call(file)
    file = File.open(file)
    csv = CSV.parse(file, headers: true, col_sep: ",")

    skipped_rows = []
    subjects = []
    
    @schedules = Schedule.all
    @schedules.destroy_all
    csv.each do |row|
        if row['PT 1'] != "CLOSED"
          user1 = User.find_by(email_id: row['PT 1'])
        
          if user1.nil?
            skipped_rows << row['PT 1']
            row['PT 1'] = "TA Not Registered"
          end
        end
        
        if row['PT 2'] != "CLOSED"
          user2 = User.find_by(email_id: row['PT 2'])
          
          if user2.nil?
            skipped_rows << row['PT 2']
            row['PT 2'] = "TA Not Registered"
          end
        end
        if row['Code'].present? && row['Course'].present?
          
          # check if course_name already exists in subjects array
          existing_subject = subjects.find { |s| s[:course_name] == row['Code'].to_s + " " + row['Course'].to_s }
          
          if existing_subject
            # concatenate the new course_section to the existing one
            existing_subject[:course_section] += ", #{row["Section"]}"
          else
            # add the new row as a new hash to the subjects array
            subjects << { course_name: row['Code'].to_s + " " + row['Course'].to_s, course_section: row["Section"] }
          end
          
        end
      
      schedule_hash = {}
      schedule_hash[:code] = row['Code']
      schedule_hash[:course_id] = row['Course']
      schedule_hash[:section] = row['Section']
      schedule_hash[:lecture_day] = row['Lecture Day']
      schedule_hash[:start_time] = row['Start Time']
      schedule_hash[:end_time] = row['End Time']
      schedule_hash[:professor] = row['Instructor']
      schedule_hash[:professor_email] = row['Instructor Email']
      schedule_hash[:students] = [row['PT 1'], row['PT 2']]

      Schedule.create(schedule_hash)
      @professor_email = row['Instructor Email']
      @professor = Professor.joins(:user).find_by(users: { email_id: @professor_email })
      if @professor.nil?
        @user = User.find_by(email_id: row['Instructor Email'])
        if @user.nil?
          # Professor.create()
          next # skip to the next iteration
        end
        @professor = Professor.create(course_list: row['Code'].to_s + " " + row['Course'].to_s, course_section: row["Section"], name: row["Instructor"], email_id: row["Instructor Email"])
      else
        @prof = Professor.find(@professor.id)
        @prof.update(course_list: row['Code'].to_s + " " + row['Course'].to_s, course_section: row["Section"], name: row["Instructor"], email_id: row["Instructor Email"])
      end

    
    end
    
    @students = Student.all
    @students.destroy_all
    # @students.each do |student|
    #   student.update(application_status: "not applied")
    # end
    unique_subjects = subjects.uniq { |subject| [subject[:course_name], subject[:course_section]] }
    @subjects = Subject.all
    @subjects.destroy_all

    Subject.create(unique_subjects)

    return skipped_rows
  end
end