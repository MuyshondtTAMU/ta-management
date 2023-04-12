# frozen_string_literal: true

class SubjectsController < ApplicationController
  before_action :set_subject, only: %i[show edit update destroy]
  before_action :admin_user

  # GET /subjects or /subjects.json
  def index
    @subjects = Subject.all
    @students_selected = Student.where("application_status='hired'")
    @course_name = Subject.pluck(:course_name).uniq
    @section_name = Subject.pluck(:course_section)
  end

  # GET /subjects/1 or /subjects/1.json
  def show; end

  # GET /subjects/new
  def new
    @subject = Subject.new
  end

  # GET /subjects/1/edit
  def edit; end

  # POST /subjects or /subjects.json
  def create
    course_sections = params[:subject][:course_section].split(',')
    subjects = []
    course_sections.each do |course_section|
      params[:subject][:course_section] = course_section
      subject = {
        'course_name' => params[:subject][:course_name],
        'course_section' => course_section
      }
      subjects.push(subject)
    end
    params[:subjects] = subjects
    begin
      Subject.transaction do
        @subjects = Subject.create!(subjects_params)
      end
      respond_to do |format|
        format.html do
          flash[:notice] = 'Courses and sections were successfully added'
          redirect_to new_subject_path
          # render json: @subjects
        end
      end
    rescue StandardError => e
      # omitting the exception type rescues all StandardErrors
      @subjects = {
        error: {
          status: 422,
          message: e.full_message
        }
      }
      respond_to do |format|
        format.html do
          flash[:alert] = "Error in adding courses " + e.message
          redirect_to new_subject_path
          # render json: @subjects
        end
      end
    end
  end

  # PATCH/PUT /subjects/1 or /subjects/1.json
  def update
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to subject_url(@subject), notice: 'Subject was successfully updated.' }
        format.json { render :show, status: :ok, location: @subject }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subjects/1 or /subjects/1.json
  def destroy
    @subject.destroy

    respond_to do |format|
      format.html { redirect_to subjects_url, notice: 'Subject was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_subject
    @subject = Subject.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def subject_params
    params.require(:subject).permit(:course_name, :course_section)
  end

  def subjects_params
    params.permit(subjects: %i[course_name course_section]).require(:subjects)
  end

  # Confirms an admin user
  def admin_user
    unless is_admin?
      flash[:danger] = "You do not have administrative access to this page."
      redirect_to user_url(session[:user_id])
    end
  end
end
