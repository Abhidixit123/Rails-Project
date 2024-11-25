class Employees::ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :check_employee
  
    def show
      # Employee profile actions
    end
  
    private
  
    def check_employee
      unless current_user.employee?
        redirect_to root_path, alert: 'Access denied: You are not an employee.'
      end
    end
  end
  
  
