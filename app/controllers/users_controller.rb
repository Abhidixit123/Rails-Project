class UsersController < ApplicationController
    before_action :authenticate_user!
  
    def show
      # Debugging: check what `params[:id]` is
      # Rails.logger.debug "Params ID: #{params[:id]}"
  
      # Make sure the ID is a valid user ID
      @user = User.find(params[:id])
    end
  end
  