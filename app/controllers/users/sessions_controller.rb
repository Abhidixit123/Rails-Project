class Users::SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!, only: [:new, :create, :destroy]
  def create
    Rails.logger.info "Login attempt for email: #{params[:user][:email]}"

    user = User.find_by(email: params[:user][:email])
    if user.nil?
      Rails.logger.info "User not found"
    elsif !user.valid_password?(params[:user][:password])
      Rails.logger.info "Invalid password for user #{user.email}"
    else
      Rails.logger.info "Login successful for user #{user.email} with role #{user.role}"
    end

    super
  end
end

