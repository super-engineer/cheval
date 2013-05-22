class PrintMediaController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"

  # GET /print_media
  # GET /print_media.json
  def index
    @print_media = PrintMedium.order("updated_at DESC").all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @print_media }
    end
  end

  # GET /print_media/1
  # GET /print_media/1.json
  def show
    @print_medium = PrintMedium.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @print_medium }
    end
  end

  # GET /print_media/new
  # GET /print_media/new.json
  def new
    @print_medium = PrintMedium.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @print_medium }
    end
  end

  # GET /print_media/1/edit
  def edit
    @print_medium = PrintMedium.find(params[:id])
  end

  # POST /print_media
  # POST /print_media.json
  def create
    @print_medium = PrintMedium.new(params[:print_medium])

    respond_to do |format|
      if @print_medium.save
        format.html { 
          redirect_to print_media_path
          gflash success: "Slider image was successfully created!" 
        }
        format.json { render json: @print_medium, status: :created, location: @print_medium }
      else
        format.html { render action: "new" }
        format.json { render json: @print_medium.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /print_media/1
  # PUT /print_media/1.json
  def update
    @print_medium = PrintMedium.find(params[:id])

    respond_to do |format|
      if @print_medium.update_attributes(params[:print_medium])
        format.html { 
          redirect_to print_media_path
          gflash success: 'Slider image was successfully updated!' 
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @print_medium.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /print_media/1
  # DELETE /print_media/1.json
  def destroy
    @print_medium = PrintMedium.find(params[:id])
    @print_medium.destroy

    respond_to do |format|
      format.html { redirect_to print_media_url }
      format.json { head :no_content }
    end
  end
end
