class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:show, :edit, :update, :destroy, :delete_attachment]
  before_action :ensure_permission, only: [:new, :create, :destroy, :index]
  before_action :ensure_current_user, only: [:delete_attachment]

  # GET /submissions
  # GET /submissions.json
  def index
    @submissions = Submission.all
  end

  # GET /submissions/1
  # GET /submissions/1.json
  def show
    @submission = Submission.find(params[:id])
  end

  # GET /submissions/new
  def new
    @submission = Submission.new
  end

  # GET /submissions/1/edit
  def edit
  end

  # POST /submissions
  # POST /submissions.json
  def create
    @submission = Submission.new(submission_params)

    respond_to do |format|
      if @submission.save
        format.html { redirect_to @submission, notice: 'Submission was successfully created.' }
        format.json { render :show, status: :created, location: @submission }
      else
        format.html { render :new }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /submissions/1
  # PATCH/PUT /submissions/1.json
  def update
    if signed_in? and current_user.type == :ta and submission_params[:feedback].blank? and params[:submission][:status] != "Open"
      flash[:alert] = "You must include feedback when the status is something other than open."
      redirect_to submission_path(@submission) and return
    end

    if params[:submission][:document] and params[:submission][:document].original_filename.downcase.ends_with?(".class")
      errors = ["<div align='center'><b>PLEASE READ:</b></div></br>Your submission was rejected because the file extension was '.class,' which means you submitted the compiled code (which only a computer can interpret).",
      "Please submit your file with the extension '.java,' which is the human-readable source code that you wrote.  Thanks!"]
      flash[:alert] = errors.join("</br></br>")
      redirect_to submission_path(@submission) and return
    end

    respond_to do |format|
      if @submission.update(submission_params)
        a = @submission.assignment
        a.status = params[:submission][:status] unless params[:submission][:status].blank?
        a.save!
        format.html { redirect_to @submission, notice: 'Submission was successfully updated.' }
        format.json { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1
  # DELETE /submissions/1.json
  def destroy
    @submission.destroy
    respond_to do |format|
      format.html { redirect_to submissions_url, notice: 'Submission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_attachment
    if Time.now < @submission.assignment.duedate
      @submission.document.destroy
      flash[:notice] = "The attachment for this submission has been removed successfully."
      redirect_to submission_path(@submission) and return
    else
      flash[:alert] = "You are not allowed to delete an attachment after the due date."
      redirect_to submission_path(@submission) and return
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission
      @submission = Submission.find(params[:id])
    end

    def ensure_permission
      if current_user.type == :student
        flash[:alert] = "You do not have permission to take this action on submissions."
        redirect_to user_path(current_user) and return
      end
    end

    def ensure_current_user
      unless (signed_in? and current_user.id == @submission.assignment.user.id)
        flash[:alert] = "You can only take this action if you are the owner of the submission."
        redirect_to user_path(current_user) and return
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def submission_params
      params.require(:submission).permit(:version_number, :feedback, :document, :rating, :private_feedback)
    end
end
