class Admin::DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
  
    def index
      # Admin dashboard actions
    end
  
    private
  
    def check_admin
      unless current_user.admin?
        redirect_to root_path, alert: 'Access denied: You are not an admin.'
      end
    end
  end
  
  