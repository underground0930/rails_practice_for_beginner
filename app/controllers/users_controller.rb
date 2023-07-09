class UsersController < ApplicationController
  before_action :correct_user, only: [:edit,:update]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to questions_path, success: 'サインアップが完了しました'
    else
      flash.now[:danger] = 'サインアップに失敗しました'
      render :new
    end
  end

  def show
    @user = User.find_by(id:params[:id])
  end

  def edit; end

  def update
    @user = User.find_by(id:params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), success: "更新に成功しました"
    else
      flash.now[:danger] = "更新に失敗しました"
      render :edit;
    end
    
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find_by(id:params[:id])
    redirect_to(root_path, status: :see_other) unless current_user?(@user)
  end

end
