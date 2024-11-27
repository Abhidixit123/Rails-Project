class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_employee, only: [:edit, :update, :show, :destroy]
  before_action :check_permissions, only: [:edit, :update, :destroy]

  def index
    # Everyone can see all employees
    @employees = Employee.all
  end

  def new
    # Only Admin or HR can create employees
    if current_user.admin? || current_user.hr?
      @employee = Employee.new
    else
      redirect_to employees_path, alert: "You don't have permission to create an employee."
    end
  end

  def create
    if current_user.admin? || current_user.hr?
      @employee = Employee.new(employee_params)

      if @employee.save
        redirect_to employees_path, notice: "Employee created successfully."
      else
        Rails.logger.debug("Employee creation failed: #{@employee.errors.full_messages}")
        flash[:alert] = @employee.errors.full_messages.to_sentence
        render :new
      end
    else
      redirect_to employees_path, alert: "You don't have permission to create an employee."
    end
  end

  def edit
    # Admin or HR can edit employee details
    unless current_user.admin? || current_user.hr?
      redirect_to employees_path, alert: "You don't have permission to edit this employee."
    end
  end

  def update
    # Admin or HR can update employee details
    if current_user.admin? || current_user.hr?
      if @employee.update(employee_params)
        redirect_to employees_path, notice: "Employee updated successfully."
      else
        flash[:alert] = "There was an error updating the employee."
        render :edit
      end
    else
      redirect_to employees_path, alert: "You don't have permission to update this employee."
    end
  end

  def show
    # Everyone can view an employee's details
  end

  def destroy
    # Only admin can delete employees
    if current_user.admin?
      if @employee.destroy
        redirect_to employees_path, notice: "Employee has been deleted successfully."
      else
        redirect_to employees_path, alert: "Failed to delete the employee."
      end
    else
      redirect_to employees_path, alert: "You don't have permission to delete this employee."
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :email, :dob, :doj, :job_title, :bio, :city, :state, :address, :user_id)
  end

  def set_employee
    @employee = Employee.find(params[:id])
  rescue ActiveRecord::RecordNotFound => error
    redirect_to employees_path, notice: "Employee not found: #{error.message}"
  end

  # Check if the current user has the right permissions to edit, update, or delete
  def check_permissions
    unless current_user.admin? || current_user.hr?
      redirect_to employees_path, alert: "You don't have permission to perform this action."
    end
  end
end
