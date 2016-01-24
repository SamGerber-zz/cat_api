class CatsController < ApplicationController

  def index
    # GET /cats
    render json: Cat.all
  end

  def show
    # GET /cats/<:id>
    render json: Cat.find(params[:id])
  end

  def create
    # POST /cats
    cat = Cat.new(name: params[:cat][:name])

    if cat.save
      render json: cat
    else
      render json: cat.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    # ...
  end

  def destroy
    # ...
  end
end
