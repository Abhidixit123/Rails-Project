class IssuedItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_issued_item, only: [:show, :edit, :update, :destroy, ]  # Add :deassign here

  def index
    if current_user.admin? || current_user.hr?
      @issued_items = IssuedItem.includes(:item, :employee)
    elsif current_user.employee?
      @issued_items = current_user.employee.issued_items.includes(:item)
    end
  end

  def new
    if current_user.admin?
      @issued_item = IssuedItem.new
      @items = Item.where("quantity > ?", 0)
    else
      redirect_to issued_items_path, alert: "You don't have permission to issue items."
    end
  end

  def create
    @issued_item = IssuedItem.new(issued_item_params)
    

    if @issued_item.save
      @issued_item.item.decrement!(:quantity)
      redirect_to issued_items_path, notice: "Item issued successfully."
    else
      Rails.logger.error("Issue Item Error: #{@issued_item.errors.full_messages}")
      flash.now[:alert] = @issued_item.errors.full_messages.to_sentence
      render :new
    end
  end

  def show
    # @issued_item is already set by set_issued_item
  end

  def edit
    @items = Item.all
    @employees = Employee.all
  end

  def update
    @issued_item = IssuedItem.find(params[:id])
    if params[:issued_item][:returned_at].present?
      ActiveRecord::Base.transaction do
        @issued_item.update!(returned_at: params[:issued_item][:returned_at], issued_at: nil,employee_id:nil)
        @issued_item.item.increment!(:quantity)
      end
      redirect_to issued_items_path, notice: "Item successfully deassigned."
      return
    end
    if params[:issued_item][:issued_at].present?
      ActiveRecord::Base.transaction do
        @issued_item.update!(issued_at: params[:issued_item][:issued_at],employee_id: params[:issued_item][:employee_id], returned_at: nil)
        @issued_item.item.increment!(:quantity)
      end
      redirect_to issued_items_path, notice: "Item successfully deassigned."
      return
    end
    redirect_to issued_items_path, notice: "Item successfully deassigned."
  end

  def destroy
    if current_user.admin?
      if @issued_item.destroy
        redirect_to issued_items_path, notice: "Issued item record deleted successfully."
      else
        redirect_to issued_items_path, alert: "Failed to delete the issued item."
      end
    else
      redirect_to issued_items_path, alert: "You don't have permission to delete this record."
    end
  end

  private

  def set_issued_item
    @issued_item = IssuedItem.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to issued_items_path, alert: "Item not found."
  end

  def issued_item_params
    params.require(:issued_item).permit(:employee_id, :issued_at, :returned_at, :item_id)
  end
end