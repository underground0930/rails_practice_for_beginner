class Admin::SessionsController < Admin::BaseController
  layout false
  skip_before_action :require_admin
  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to admin_questions_path
    else
      render :new
    end
  end
end
