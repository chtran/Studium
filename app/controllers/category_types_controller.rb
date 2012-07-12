class CategoryTypesController < ApplicationController
  def new 
    @category_type = CategoryType.new
  end

  def create
    @category_type = CategoryType.create(params[:category_type])
    if @category_type.save 
      redirect_to category_types_path
      flash[:notice] = 'Category has been created.'
    end
  end

  def index
    @category_types = CategoryType.all
  end

end
