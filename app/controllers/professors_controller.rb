class ProfessorsController < ApplicationController
  before_action :set_professor, only: %i[ show edit update destroy ]
  # before_action :require_user_logged_in!

  # GET /professors or /professors.json
  def index
    @professors = Professor.all
    @assign = Assignment.find_by(professor_id: @professor.id)
    @student = Student.find(@assign.student_id)
  end

  # GET /professors/1 or /professors/1.json
  def show
    @assign = Assignment.find_by(professor_id: @professor.id)
    @student = Student.find(@assign.student_id)
    if (params[:students])
      @student.feedback = params[:students][:review]
      if ((@student.feedback).length > 0)
        @student.save
      end
    end
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
    @professor = Professor.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def professor_params
    params.require(:professor).permit(:name, :email_id, :course_list, :course_section, :student_review)
  end

  def update_professor
    @professor = Professor.find(params[:id])
    @professor.name = params[:professor][:name]
    @professor.email_id = params[:professor][:email_id]
    @professor.save
  end
end
