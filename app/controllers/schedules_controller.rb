class SchedulesController < ApplicationController
    before_action :admin_user
    
    @@skipped_rows = []
    
    def import
       # binding.b
        if params[:file].nil?
            return redirect_to schedules_path, notice: "You did not select any file. Try again"
        else
            file = params[:file]
            return redirect_to schedules_path, notice: "Only CSV file please" unless file.content_type == "text/csv"   
        end
        #CsvImportUsersService.new.call(file)
        @@skipped_rows = CsvImportUsersService.new.call(file)
        
        #store_skipped_pts(@skipped_pts)
        
        redirect_to admin_path, notice: "Successfully imported"
    end
    def index
        @schedules = Schedule.all
    end

    def view
        @schedules = Schedule.all
        @skipped_rows = @@skipped_rows
        # @@skipped_rows
        puts "Testing 1"
        puts @skipped_rows.length()
        puts "Testing"
        
        # if @skipped_rows.any?
        #     skipped_rows_msg = "The following rows were not saved: "
        #     @skipped_rows.each do |row|
        #         # skipped_rows_msg ||= ""
        #         skipped_rows_msg += row.inspect + "; "
        #     end
        #     flash[:warning] = skipped_rows_msg
        # end
    end

    def destroy
        @schedules = Schedule.all
        @schedules.destroy_all
        @students = Student.all
        @students.each do |student|
          student.update(application_status: "not applied")
        end
        @subjects = Subject.all
        @subjects.destroy_all
        @students = Student.all
        @students.destroy_all
        respond_to do |format|
          format.html { redirect_to admin_url, notice: "Schedules were successfully removed." }
          format.json { head :no_content }
        end
        @@skipped_rows = []
    end
    
    
    # skipped_rows = import
    # view(skipped_rows)
    private
        
     # Confirms an admin user
      def admin_user
        unless is_admin?
          flash[:danger] = "You do not have administrative access to this page."
          redirect_back(fallback_location: { action: "show", id: session[:user_id]})
        end
      end
        def store_skipped_pts(skipped_pts)
            return @skipped_pts
        end
end