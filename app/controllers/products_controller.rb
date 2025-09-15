class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: "Product created successfully."
    else
      render :new
    end
  end

  # edit, update, destroy similar

  private

  def require_admin
    redirect_to pages_home_path, alert: "Access denied." unless current_user.admin?
  end

  def product_params
    params.require(:product).permit(:name, :price, :description)
  end
end
