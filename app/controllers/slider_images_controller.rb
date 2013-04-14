class SliderImagesController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"

  # GET /slider_images
  # GET /slider_images.json
  def index
    @slider_images = SliderImage.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @slider_images }
    end
  end

  # GET /slider_images/1
  # GET /slider_images/1.json
  def show
    @slider_image = SliderImage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @slider_image }
    end
  end

  # GET /slider_images/new
  # GET /slider_images/new.json
  def new
    @slider_image = SliderImage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @slider_image }
    end
  end

  # GET /slider_images/1/edit
  def edit
    @slider_image = SliderImage.find(params[:id])
  end

  # POST /slider_images
  # POST /slider_images.json
  def create
    @slider_image = SliderImage.new(params[:slider_image])

    respond_to do |format|
      if @slider_image.save
        format.html { 
          redirect_to slider_images_path
          gflash success: "Slider image was successfully created!" 
        }
        format.json { render json: @slider_image, status: :created, location: @slider_image }
      else
        format.html { render action: "new" }
        format.json { render json: @slider_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /slider_images/1
  # PUT /slider_images/1.json
  def update
    @slider_image = SliderImage.find(params[:id])

    respond_to do |format|
      if @slider_image.update_attributes(params[:slider_image])
        format.html { 
          redirect_to slider_images_path
          gflash success: 'Slider image was successfully updated!' 
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @slider_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /slider_images/1
  # DELETE /slider_images/1.json
  def destroy
    @slider_image = SliderImage.find(params[:id])
    @slider_image.destroy

    respond_to do |format|
      format.html { redirect_to slider_images_url }
      format.json { head :no_content }
    end
  end
end
