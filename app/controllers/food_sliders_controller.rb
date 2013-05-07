class FoodSlidersController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  # GET /food_sliders
  # GET /food_sliders.json
  def index
    @food_sliders = FoodSlider.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @food_sliders }
    end
  end

  # GET /food_sliders/1
  # GET /food_sliders/1.json
  def show
    @food_slider = FoodSlider.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @food_slider }
    end
  end

  # GET /food_sliders/new
  # GET /food_sliders/new.json
  def new
    @food_slider = FoodSlider.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @food_slider }
    end
  end

  # GET /food_sliders/1/edit
  def edit
    @food_slider = FoodSlider.find(params[:id])
  end

  # POST /food_sliders
  # POST /food_sliders.json
  def create
    @food_slider = FoodSlider.new(params[:food_slider])

    respond_to do |format|
      if @food_slider.save
        format.html { redirect_to food_sliders_url, notice: 'Food slider was successfully created.' }
        format.json { render json: @food_slider, status: :created, location: @food_slider }
      else
        format.html { render action: "new" }
        format.json { render json: @food_slider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /food_sliders/1
  # PUT /food_sliders/1.json
  def update
    @food_slider = FoodSlider.find(params[:id])

    respond_to do |format|
      if @food_slider.update_attributes(params[:food_slider])
        format.html { redirect_to food_sliders_url, notice: 'Food slider was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @food_slider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /food_sliders/1
  # DELETE /food_sliders/1.json
  def destroy
    @food_slider = FoodSlider.find(params[:id])
    @food_slider.destroy

    respond_to do |format|
      format.html { redirect_to food_sliders_url }
      format.json { head :no_content }
    end
  end
end
