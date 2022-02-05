class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update, :show, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if(@user.save)
      flash[:success] = "Welcome to Alpha Blog #{@user.username}"
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 2)
  end

  def edit

  end

  def update
      if @user.update(user_params)
        flash[:success] = "Your account was successfully updated."
        redirect_to articles_path
      else
        render 'edit'
      end
  end

  def destroy
    @user.destroy
    flash[:danger] = "User and all articles of user have been deleted."
    redirect_to user_path, status: 303
  end

  private
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def require_same_user
      if current_user != @user && !current_user.admin?
        flash[:danger] = "You can only edit your own information."
        redirect_to articles_path
      end
    end

    def require_admin
      if logged_in? and !current_user.admin?
        flash[:danger] = "Only admin can perform this action."
        redirect_to articles_path
      end
    end
end
