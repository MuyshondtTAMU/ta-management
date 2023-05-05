class ProfessorsController < ApplicationController
  before_action :set_professor, only: %i[ show edit update destroy ]
  # before_action :management_user, only: [:index]
  before_action :admin_user
  # before_action :require_user_logged_in!

  # GET /professors or /professors.json
  def index
    @professors = Professor.all
    # @students = []
    @professors1 = []
    # <% Assignment.find_by(student_id: student.id) %>
    @professors.each do |professor|
      # puts professor.id
      assign = Assignment.find_by(professor_id: professor.id)
      if assign
        professor1 = Professor.find(assign.professor_id)
        # student = Student.find(assign.student_id)
        @professors1 << professor1
        # @students << student
        # puts "Testing"
        # puts student.id
      end
    # puts "Enddddd"
    
    # puts @students[0]
  end
    
    
    # @professor = Professor.find_by(user_id: session[:user_id])
    # @assign = Assignment.find_by(professor_id: @professor.id)
    # @student = Student.find(@assign.student_id)
  end

  # GET /professors/1 or /professors/1.json
  def show
    # puts @professor.id
    # puts "Enddd"
    @assign = Assignment.where(professor_id: @professor.id)
    @students = []
    if @assign.any?

      @assign.each do |ass|
        @student = Student.find(ass.student_id)
        @students << @student
        if (params[:students])
          @student.feedback = params[:students][:review]
          if ((@student.feedback).length > 0)
            @student.save
          end
        end
      end
    end
    # puts @students[0].user_id
    # puts @students[1].user_id
  end

  # GET /professors/new
  def new
    @courses = Subject.pluck(:course_name, :course_section)
    @professor = Professor.new
  end

  # GET /professors/1/edit
  def edit; end

  # POST /professors or /professors.json
  def create
    if params[:update]
      update_professor
      return
    end
    @professor = Professor.new(professor_params)
    @professor.course_list = params[:course_list]
    @professor.course_section = params[:course_section]
    respond_to do |format|
      if @professor.save
        format.html { redirect_to new_professor_url, notice: 'Professor was successfully assigned the course' }
        format.json { render :show, status: :created, location: @professor }
      else
        flash[:alert] = @professor.errors.full_messages
        format.html {  redirect_to new_professor_url}
        format.json { render json: @professor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /professors/1 or /professors/1.json
  def update
    respond_to do |format|
      if @professor.update(professor_params)
        format.html { redirect_to professor_url(@professor), notice: 'Professor was successfully updated with new course' }
        format.json { render :show, status: :ok, location: @professor }
      else
        flash[:alert] = @professor.errors.full_messages
        format.html { redirect_to edit_professor_path, status: :unprocessable_entity }
        format.json { render json: @professor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /professors/1 or /professors/1.json
  def destroy
    @professor.destroy

    respond_to do |format|
      format.html { redirect_to professors_url, notice: 'Professor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_professor
      @professor = Professor.find_by_user_id(session[:user_id])
    end
  
    # Only allow a list of trusted parameters through.
    def professor_params
      params.require(:professor).permit(:name, :email_id, :course_list, :course_section, :student_review)
    end
  
    def update_professor
      @professor_email = params[:professor][:email_id]
      @professor = Professor.joins(:user).find_by(users: { email_id: :professor_email })
    
      
      # @professor = Professor.find(params[:id])
      # @professor.name = params[:professor][:name]
      # @professor.email_id = params[:professor][:email_id]
      # @professor.save
    end
    
    # Confirms an admin user
    def admin_user
      unless is_admin?
        flash[:danger] = "You do not have administrative access to this page."
        redirect_back(fallback_location: { action: "show", id: session[:user_id]})
      end
    end
  
        # Confirms a coordinator user
    # def management_user
    #   unless is_management?
    #     flash[:danger] = "You do not have administrative access to this page."
    #     redirect_to user_url(session[:user_id])
    #   end
    # end
end
