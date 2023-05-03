class StudentsController < ApplicationController
  # before_action :set_student, only: %i[show edit update destroy]
  
  before_action :logged_in_user, only: [:new, :create]
  before_action :management_user, only: [:index, :show, :search_students, :edit, :update, :destroy, :delete]
  # before_action :professor_user, only: [:show]
  # before_action :coordinator_user, only: [:index, :search_students, :show, :edit, :update, :destroy, :delete]
  # before_action :logged_in!

  # GET /students or /students.json
  def index
    @students = Student.all.page(params[:page]).per(20)
    search_students if params[:search]
    if !params[:sort].nil?
      @students = Student.order(params[:sort]).page(params[:page]).per(20)
    else
      @student = Student.all.page(params[:page]).per(20)
    end
  end

  def search_students
    if @student = Student.all.find { |student| student.user.name.downcase.include?(params[:search].downcase) }
      redirect_to student_url(@student)
    end
  end

  # GET /students/1 or /students/1.json
  def show
    @student = Student.find(params[:id])
  end

  # GET /students/new
  def new
    @student = Student.new
    # @student2 = Student.find_by_user_id(session[:user_id])
    
    # flash[:alert] = "Your name and email id are already set as #{@user.name} and #{@user.email_id}"
  end

  # GET /students/1/edit
  def edit; end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)
    @user = User.find_by_id(session[:user_id])
    process_params
    respond_to do |format|
      if @student.save

        format.html { redirect_to user_url(@user), notice: 'Application was successfully submitted.' }
        format.json { render :show, status: :created, location: @student }
      else
        flash[:alert] = @student.errors.full_messages
        format.html { redirect_to new_student_path }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    @student = Student.find_by(id: params[:id])
    respond_to do |format|
      if params[:subjects_page]
        if @student.present? && @student.update(update_params)
          format.html { redirect_to subjects_path, notice: 'Subject was successfully assigned to student.' }
          format.json { render :show, status: :ok, location: @student }
        else
          flash[:alert] = @student.errors.full_messages
          format.html { redirect_to subjects_path }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      elsif params[:students_page]
        
        if @student.present? && @student.update(update_params)
          format.html { redirect_to students_url, notice: 'Student status was successfully updated.' }
          format.json { render :show, status: :ok, location: @student }
        else
          flash[:alert] = @student.errors.full_messages
          format.html { redirect_to students_url }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      else
        if @student.update(update_params)
          format.html { redirect_to student_url(@student), notice: 'Student application was successfully updated.' }
          format.json { render :show, status: :ok, location: @student }
        else
          flash[:alert] = @student.errors.full_messages
          format.html { redirect_to edit_student_path }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      end


    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy

    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #Internal API for soft delete
  def delete
    @student.is_active = false
    @student.save!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  # def set_student
  #   @student = Student.find(params[:id])
  # end

  # Only allow a list of trusted parameters through.
  def student_params
    params.require(:student).permit(:uin, :employment_status, :is_undergrad, :courses_completed, :resume, :transcript, :access_level, :application_status, :comments, :assigned_courses, :assigned_sections, :rating, :feedback, :sections, :user_id)
  end

  def process_params
    # @student.name = params[:student][:name] == @user.name
    # @student.email_id = params[:student][:email_id] == @user.email_id
    @student.employment_status = params[:student][:employment_status] == 'Yes'
    @student.is_undergrad = params[:student][:is_undergrad] == 'Yes'
    @student.courses_completed = params[:student][:courses_completed] == 'Both' ? %w[102 216] : [params[:student][:courses_completed]]
    @student.user_id = session[:user_id]
    @student.application_status = "applied"
  end

  def update_params
    map = params.require(:student).permit(:name, :email_id, :uin, :employment_status, :is_undergrad, :courses_completed, :resume, :transcript, :access_level, :application_status, :comments, :assigned_courses, :assigned_sections, :rating, :feedback, :subjects)

    if params[:student].has_key?(:employment_status)
      map['employment_status'] = params[:student][:employment_status] == 'Yes'
    end
    if params[:student].has_key?(:is_undergrad)
      map['is_undergrad'] = params[:student][:is_undergrad] == 'Yes'
    end
    if params[:student].has_key?(:courses_completed)
      map['courses_completed'] = params[:student][:courses_completed] == 'Both' ? %w[102 216] : [params[:student][:courses_completed]]
    end

    if params[:student].has_key?(:assigned_courses) && params[:student].has_key?(:assigned_sections)
      course = params[:student][:assigned_courses]
      sections = params[:student][:assigned_sections]
      map['assigned_courses'] = course.split(",")
      sections_list = sections.split(",")
      map['assigned_sections'] = sections_list
      sections_list.each { |section|
        assign(course, section)
      }
    end
    # if(params[:student].has_key?(:assigned_sections))
    #   map["assigned_sections"] = [params[:student][:assigned_sections]]
    # end
    return map
  end

  def assign(course, section)
    # professor = Professor.find_by(course_list: course,course_section:section)
    # subject = Subject.find_by(course_name: course, course_section: section)
    puts "Here is where ypu should print"
    puts @student.id
    puts @student.user.id
    puts "Print after that"
    professor = Professor.find_by(course_list: course)
    subject = Subject.find_by(course_name: course)
    student = Student.find_by(id: params[:id])
    puts "Another one"
    puts student
    puts "end of discussion"
    assignment = Assignment.new
    assignment.subject = subject
    assignment.student = student
    assignment.professor = professor
    assignment.save!
  end
  
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # Confirms an admin user
  # def admin_user
  #   unless is_admin?
  #     flash[:danger] = "You do not have administrative access to this page."
  #     redirect_to user_url(session[:user_id])
  #   end
  # end
  
  
    # Confirms a coordinator user
  def management_user
    unless is_management?
      flash[:danger] = "You do not have administrative access to this page."
      redirect_to user_url(session[:user_id])
    end
  end
  
  # Confirms a coordinator user
  def professor_user
    unless is_professor?
      flash[:danger] = "You are not an instructor."
      redirect_to user_url(session[:user_id])
    end
  end
end
