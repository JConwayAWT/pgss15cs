class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :ensure_current_user, only: [:show, :edit, :update, :destroy]


  # GET /users
  # GET /users.json
  def index
    if signed_in?
      redirect_to after_sign_in_path_for(current_user) and return
    else
      @users = User.all
    end
  end

  def list
    if signed_in? and current_user.type == :ta
      @students = []
      User.all.each do |u|
        @students << u if u.type != :ta
      end
      @students = @students.sort_by {|s| s.last_name}
    else
      flash[:alert] = "You do not have permission to access this page."
      redirect_to user_path(current_user) and return
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    redirect_to new_user_registration_path
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def student_review
    if signed_in? and current_user.type == :ta
      @students = []
      User.all.each do |u|
        @students << u if u.type == :student
      end
      @students.sort_by!{|u| u.last_name}
    else
      flash[:alert] = "You do not have permission to access this page."
      redirect_to user_path(current_user) and return
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def ensure_current_user
      if params[:id].to_i != current_user.id and current_user.type != :ta
        flash[:alert] = "You do not have permission to perform this action on other users."
        redirect_to user_path(current_user) and return
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :advanced_lab, :cs_advanced_section)
    end
end
