class Api::MenusController < ApplicationController

  before_action :set_menu, only: [:show, :update, :destroy]

  def index
    render json: Menu.all, include: :menu_items, status: :ok
  end

  def show
    render json: @menu, include: :menu_items, status: :ok
  end

  def create
    @menu = Menu.new(menu_params)
    if @menu.save
      render json: @menu, include: :menu_items, status: :created
    else
      render json: { errors: @menu.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @menu.update(menu_params)
      render json: @menu, include: :menu_items, status: :ok
    else
      render json: { errors: @menu.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @menu.destroy
    head :no_content
  end

  private

  def set_menu
    @menu = Menu.find(params[:id])
  end

  def menu_params
    params.require(:menu).permit(:name)
  end
end
