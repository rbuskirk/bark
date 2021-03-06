class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :like, :update, :destroy]

  # GET /dogs
  # GET /dogs.json
  def index
    @dogs = Dog.paginate(:page => params[:page], :per_page => 5)
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)
    @dog.user_id = current_user.id if current_user.present?

    respond_to do |format|
      if @dog.save
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    redirect_back fallback_location: root_path, notice: 'User is not owner' unless owner?(@dog)

    respond_to do |format|
      if @dog.update(dog_params)
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    redirect_back fallback_location: root_path, notice: 'User is not owner' unless owner?(@dog)

    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /dogs/1/like
  # not the ideal solution as it will allow for users to like a dog more then once
  def like
    if owner?(@dog)
      redirect_back fallback_location: root_path, notice: 'Dogs cannot be liked by their owners.' if owner?(@dog)
    else
      @dog.increment!(:likes, 1)
      respond_to do |format|
        format.html { redirect_to @dog, notice: 'Dog was successfully liked.' }
        format.json { render :show, status: :ok, location: @dog }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params.require(:dog).permit(:name, :description, :images)
    end

    def owner?(dog)
      current_user == dog.user
    end
end
