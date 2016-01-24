class CatsController < ApplicationController

  def index
    # GET /cats
    @cats = Cat.all
    render :index
  end

  def show
    # GET /cats/<:id>
    @cat = Cat.find(params[:id])
    render :show
  end

  def create
    # POST /cats
    cat = Cat.new(params[:cat].permit(:name))

    if cat.save
      render json: cat
    else
      render json: cat.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    cat = Cat.find(params[:id])
    # if I upload an admin attribute, this tries to set cat.admin
    cat.update(params[:cat].permit(:name))
  end

  def destroy
    # if !current_cat_user.admin
    #   raise "error"
    # end
    # ...
  end
end
