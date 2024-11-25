class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_document, only: [:edit, :update, :show, :destroy]
  before_action :authorize_user!, except: [:index, :new, :create]

  # def index
  #   if current_user.admin? || current_user.hr?
  #     @documents = Document.all
  #   elsif current_user.employee?
  #     # Employees can only see documents associated with their employee record
  #     if current_user.employee
  #        @documents = Document.where(employee_id: current_user.id)
       
  #     else
  #       @documents = []
  #       flash[:alert] = "No associated employee record found."
  #     end
  #   else
  #     @documents = []
  #   end
  # end

  def index
    if current_user.admin? || current_user.hr?
      @documents = Document.all
    elsif current_user.employee?
      begin
        @documents = current_user.employee.documents
      rescue NoMethodError
        @documents = [] # If current_user has no associated employee
      end
    else
      @documents = [] # Fallback for users with no document access
    end
  end
  




  def new
    @document = Document.new
  end

  def create
    Rails.logger.debug "Starting create action. Current user: #{current_user.inspect}"
  
    @document = Document.new(document_params)
  
    if current_user.admin? || current_user.hr?
      # Admins or HR must assign the document to an employee
      if document_params[:employee_id].present?
        @document.employee_id = document_params[:employee_id]
      else
        flash[:alert] = "You must assign the document to an employee."
        render :new
        return
      end
    elsif current_user.employee?
      # Employees can only create documents for themselves
      if current_user.employee
        @document.employee_id = current_user.employee.id
      else
        redirect_to root_path, alert: "No associated employee record found. Please contact admin."
        return
      end
    else
      redirect_to root_path, alert: "You are not authorized to create documents."
      return
    end
  
    if @document.save
      Rails.logger.debug "Document created successfully: #{@document.inspect}"
      redirect_to documents_path, notice: 'Document has been created successfully.'
    else
      Rails.logger.error "Failed to create document. Errors: #{@document.errors.full_messages}"
      flash[:alert] = @document.errors.full_messages.to_sentence
      render :new
    end
  end
  

  def edit
    unless current_user.admin? || current_user.hr?
      redirect_to documents_path, alert: "You are not authorized to edit this document."
    end
  end

  def update
    if current_user.admin? || current_user.hr?
      if @document.update(document_params)
        redirect_to documents_path, notice: 'Document updated successfully.'
      else
        flash[:alert] = @document.errors.full_messages.to_sentence
        render :edit
      end
    else
      redirect_to documents_path, alert: "You are not authorized to update this document."
    end
  end

  def show
    if current_user.employee? && @document.employee_id != current_user.employee&.id
      redirect_to documents_path, alert: "You are not authorized to view this document."
    end
  end

  def destroy
    if current_user.admin?
      if @document.destroy
        redirect_to documents_path, notice: 'Document deleted successfully.'
      else
        redirect_to documents_path, alert: 'Failed to delete the document.'
      end
    else
      redirect_to documents_path, alert: "You are not authorized to delete this document."
    end
  end

  private

  def document_params
    params.require(:document).permit(:name, :doc_type, :employee_id, :image)
  end

  def set_document
    @document = Document.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to documents_path, alert: "Document not found."
  end

  def authorize_user!
    Rails.logger.debug "Authorizing user: #{current_user.inspect}, action: #{action_name}"

    if current_user.employee? && action_name.in?(%w[edit update destroy])
      redirect_to documents_path, alert: 'Employees cannot modify or delete documents.'
    elsif current_user.hr? && action_name == 'destroy'
      redirect_to documents_path, alert: 'HR cannot delete documents.'
    end
  end
end
