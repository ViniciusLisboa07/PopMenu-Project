class Api::MenuItemsController < ApplicationController
  before_action :set_menu, only: [:index, :create, :show, :update, :destroy], if: :nested_route?
  before_action :set_menu_item, only: [:show, :update, :destroy]

  def index
    @menu_items = if @menu
                    @menu.menu_items
                  else
                    MenuItem.all
                  end
    render json: @menu_items, status: :ok
  end

  def show
    render json: @menu_item, status: :ok
  end

  def create
    @menu_item = MenuItem.new(menu_item_params)
    if @menu_item.save
      MenuMenuItem.create!(menu_id: @menu.id, menu_item_id: @menu_item.id) if @menu.present?
      render json: @menu_item, include: [:menus], status: :created
    else
      render json: { errors: @menu_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @menu_item.update(menu_item_params)
      render json: @menu_item, include: [:menus], status: :ok
    else
      render json: { errors: @menu_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @menu_item.destroy
    head :no_content
  end

  private

  def set_menu
    @menu = Menu.find(params[:menu_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Menu not found' }, status: :not_found
  end

  def set_menu_item
    @menu_item = if @menu
                   @menu.menu_items.find(params[:id])
                 else
                   MenuItem.find(params[:id])
                 end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Menu item not found' }, status: :not_found
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :description, :price)
  end

  def nested_route?
    params[:menu_id].present?
  end
end