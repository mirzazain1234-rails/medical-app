class DepartmentsController < ApplicationController
  def index
    @products = Product.all
  end
end
