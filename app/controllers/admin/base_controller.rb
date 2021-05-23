class Admin::BaseController < ApplicationController
  layout 'admin/layouts/application'
  before_action :require_admin

  def require_admin
    redirect_to questions_path unless current_user&.admin?
  end
end
