class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :require_user, :only => [:create, :new, :confirm_email]

  # GET /users
  # GET /users.json
  def index
    @users = User.order('first_name ASC')
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      UsersMailer.registration_confirmation(@user).deliver
      flash[:success] = 'Success! Confirm your email to continue.'
      redirect_to @user
    else
      flash[:danger] = 'Whoops, that didn\'t work!'
      render 'new'
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      flash[:success] = 'User was successfully updated.'
      redirect_to @user
    else
      flash[:danger] = 'Whoops, that didn\'t work!'
      render 'edit'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    flash[:success] = 'User was successfully destroyed.'
    redirect_to users_url
  end

  def confirm_email
    user = User.find_by(confirm_token: params[:id])
    if user
      user.email_activate
      flash[:success] = "Your email has been confirmed."
      redirect_to login_url
    else
      flash[:danger] = "We couldn't find that user."
      redirect_to root_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password)
    end
end
