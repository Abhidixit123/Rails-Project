class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:show, :edit, :update, :destroy]


  def index
    if current_user.admin?
      @items = Item.all
    elsif current_user.hr?
      @items = Item.where(issued: true) # Or filter as needed
    elsif current_user.employee?
      @items = current_user.employee.items
    else
      @items = [] # Fallback if user has no specific access
    end
  end

  def show
    @issued_items = @item.issued_items.includes(:employee)
  end

  def new
    if current_user.admin?
      @item = Item.new
    else
      redirect_to items_path, alert: "You are not authorized to create items."
    end
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to items_path, notice: "Item created successfully."
    else
      flash[:alert] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    unless current_user.admin?
      redirect_to items_path, alert: "You are not authorized to edit items."
    end
  end

  def update
    if current_user.admin?
      if @item.update(item_params)
        redirect_to items_path, notice: "Item updated successfully."
      else
        flash[:alert] = @item.errors.full_messages.to_sentence
        render :edit
      end
    else
      redirect_to items_path, alert: "You are not authorized to update items."
    end

  end

  def destroy
    if current_user.admin?
      @item.destroy
      redirect_to items_path, notice: "Item deleted successfully."
    else
      redirect_to items_path, alert: "You are not authorized to delete items."
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to items_path, alert: "Item not found."
  end

  def item_params
    params.require(:item).permit(:name, :description, :quantity, :issued, :issued_to, :category, :price)
  end
end