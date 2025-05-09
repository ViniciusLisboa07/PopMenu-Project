class Api::MenusController < ApplicationController
  before_action :set_restaurant, only: [:index, :create], if: :nested_route?
  before_action :set_menu, only: [:show, :update, :destroy]

  def index
    @menus = if @restaurant
               @restaurant.menus
             else
               Menu.all
             end
    render json: @menus, include: [:menu_items, :restaurant], status: :ok
  end

  def show
    render json: @menu, include: [:menu_items, :restaurant], status: :ok
  end

  def create
    @menu = if @restaurant
              @restaurant.menus.build(menu_params)
            else
              Menu.new(menu_params)
            end
    if @menu.save
      render json: @menu, include: [:menu_items, :restaurant], status: :created
    else
      render json: { errors: @menu.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @menu.update(menu_params)
      render json: @menu, include: [:menu_items, :restaurant], status: :ok
    else
      render json: { errors: @menu.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @menu.destroy
    head :no_content
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Restaurant not found' }, status: :not_found and return
  end

  def set_menu
    @menu = Menu.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Menu not found' }, status: :not_found
  end

  def menu_params
    params.require(:menu).permit(:name, :description, :active, :restaurant_id)
  end

  def nested_route?
    params[:restaurant_id].present?
  end
end