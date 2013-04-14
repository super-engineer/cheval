class PressLinksController < ApplicationController
  before_filter :authenticate_admin!
  layout "admin"
  # GET /press_links
  # GET /press_links.json
  def index
    @press_links = PressLink.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @press_links }
    end
  end

  # GET /press_links/1
  # GET /press_links/1.json
  def show
    @press_link = PressLink.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @press_link }
    end
  end

  # GET /press_links/new
  # GET /press_links/new.json
  def new
    @press_link = PressLink.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @press_link }
    end
  end

  # GET /press_links/1/edit
  def edit
    @press_link = PressLink.find(params[:id])
  end

  # POST /press_links
  # POST /press_links.json
  def create
    @press_link = PressLink.new(params[:press_link])

    respond_to do |format|
      if @press_link.save
        format.html { 
          redirect_to press_links_path
          gflash success: 'Press link was successfully created.' 
        }
        format.json { render json: @press_link, status: :created, location: @press_link }
      else
        format.html { render action: "new" }
        format.json { render json: @press_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /press_links/1
  # PUT /press_links/1.json
  def update
    @press_link = PressLink.find(params[:id])

    respond_to do |format|
      if @press_link.update_attributes(params[:press_link])
        format.html { 
          redirect_to press_links_path
          gflash success: 'Press link was successfully updated.' 
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @press_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /press_links/1
  # DELETE /press_links/1.json
  def destroy
    @press_link = PressLink.find(params[:id])
    @press_link.destroy

    respond_to do |format|
      format.html { redirect_to press_links_url }
      format.json { head :no_content }
    end
  end
end
