class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email_or_name]) || User.find_by(name: params[:email_or_name])
    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to questions_path, success: 'ログインしました'
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, success: 'ログアウトしました'
  end
end
