class Hr::DocumentsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_hr
  
    def index
      # HR document actions
    end
  
    def edit
      # HR document edit actions
    end
  
    private
  
    def check_hr
      unless current_user.hr?
        redirect_to root_path, alert: 'Access denied: You are not an HR user.'
      end
    end
  end
  
  
