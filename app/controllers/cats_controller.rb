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
    @cat = Cat.new(params[:cat].permit(:name))

    if @cat.save
      redirect_to cat_url @cat
    else
      render json: cat.errors.full_messages, status: :unprocessable_entity
    end
  end

  # 1. GET /cats/new to fetch a form
  # 2. USER fills out form, clicks submit.
  # 3. POST /cats the data in the form.
  # 4. Create action is invoked, cat is created
  # 5. Send client a redirect to /cats/:id
  # 6. Client makes a GET request for /cats/:id
  # 7. Show action for newly created cat is invoked.

  def new
    # /cats/new
    # show a form to create a new object
  end

  def update
    cat = Cat.find(params[:id])
    # if I upload an admin attribute, this tries to set cat.admin
    cat.update(params[:cat].permit(:name))
  end

  def edit
    # /cats/:id/edit
    # show a form to edit a given object
  end

  def destroy
    cat = Cat.find(params[:id])
    cat.destroy
    redirect_to cats_url

    # GET /cats
    # Click delete button
    # Sends POST to /cats/123; but the _method = "DELETE" so rails
    # understands it's a destroy
    # destroy the cat
    # issue redirect to /cats
    # client gets /cats again
  end
end
