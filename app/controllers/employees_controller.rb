class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_employee, only: [:edit, :update, :show, :destroy]
  before_action :check_permissions, only: [:edit, :update, :destroy]

  def index
    # Admin can see all employees, HR can see employees too (if needed, we can filter here).
    if current_user.admin?
      @employees = Employee.all
    elsif current_user.hr?
      @employees = Employee.all # HR can also see all employees, modify this filter if necessary.
    else
      @employees = Employee.all # Employees can only see themselves
    end
  end

  def new
    # Only Admin or HR can create employees.
    if current_user.admin? || current_user.hr?
      @employee = Employee.new
    else
      redirect_to root_path, alert: "You don't have permission to create an employee."
    end
  end

  def create
    @employee = Employee.new(employee_params)
    
    # @employee.user_id = current_user.id if current_user

    if @employee.save
      redirect_to employees_path, notice: "Employee created successfully."
    else
      Rails.logger.debug("Employee creation failed: #{@employee.errors.full_messages}")
      flash[:alert] = @employee.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    # Admin or HR can edit employee details
    unless current_user.admin? || current_user.hr?
      redirect_to root_path, alert: "You don't have permission to edit this employee."
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
      redirect_to root_path, alert: "You don't have permission to update this employee."
    end
  end

  def show
    # Employees can only see their own profile
    if current_user.employee? && current_user != @employee
      redirect_to root_path, alert: "You can only view your own profile."
    end
  end

  def destroy
    if current_user.admin? # Only admin can delete employees
      if @employee.destroy
        redirect_to employees_path, notice: 'Employee has been deleted successfully.'
      else
        redirect_to employees_path, alert: 'Failed to delete the employee.'
      end
    else
      redirect_to root_path, alert: "You don't have permission to delete this employee."
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

  # Check if the current user has the right permissions to edit, update or delete
  def check_permissions
    if current_user.employee? && current_user != @employee
      redirect_to root_path, alert: "You can only edit your own profile."
    end
  end
end
