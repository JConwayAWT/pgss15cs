class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]
  before_action :ensure_permission, only: [:new, :create, :edit, :update, :destroy, :index]

  # GET /assignments
  # GET /assignments.json
  def index
    @assignments = Assignment.where('status != ?', "Complete")
  end

  # GET /assignments/1
  # GET /assignments/1.json
  def show
  end

  # GET /assignments/new
  def new
    @assignment = Assignment.new
  end

  # GET /assignments/1/edit
  def edit
  end

  # POST /assignments
  # POST /assignments.json
  def create
    #begin
      Assignment.create_assignment_for_all_students(assignment_params, params)
      flash[:notice] = "New assignment and submissions were created successfully for all students."
      redirect_to assignments_path
  end

  # PATCH/PUT /assignments/1
  # PATCH/PUT /assignments/1.json
  def update
    respond_to do |format|
      if @assignment.update(assignment_params)
        format.html { redirect_to @assignment, notice: 'Assignment was successfully updated.' }
        format.json { render :show, status: :ok, location: @assignment }
      else
        format.html { render :edit }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.json
  def destroy
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to assignments_url, notice: 'Assignment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    def ensure_permission
      if !signed_in? or current_user.type == :student
        flash[:alert] = "You do not have permission to take this action on assignments."
        if signed_in?
          redirect_to user_path(current_user) and return
        else
          redirect_to new_user_session_path
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assignment_params
      params.require(:assignment).permit(:name, :status, :duedate)
    end
end
