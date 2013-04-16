class SpecialMenusController < ApplicationController
  layout 'admin'

  # GET /special_menus
  # GET /special_menus.json
  def index
    @special_menus = SpecialMenu.unscoped.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @special_menus }
    end
  end

  # GET /special_menus/1
  # GET /special_menus/1.json
  def show
    @special_menu = SpecialMenu.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @special_menu }
    end
  end

  # GET /special_menus/new
  # GET /special_menus/new.json
  def new
    @special_menu = SpecialMenu.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @special_menu }
    end
  end

  # GET /special_menus/1/edit
  def edit
    @special_menu = SpecialMenu.unscoped.find(params[:id])
  end

  # POST /special_menus
  # POST /special_menus.json
  def create
    @special_menu = SpecialMenu.new(params[:special_menu])

    respond_to do |format|
      if @special_menu.save
        format.html { 
          gflash success: 'Special menu was successfully created.' 
          redirect_to special_menus_path
        }
        format.json { render json: @special_menu, status: :created, location: @special_menu }
      else
        format.html { render action: "new" }
        format.json { render json: @special_menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /special_menus/1
  # PUT /special_menus/1.json
  def update
    @special_menu = SpecialMenu.unscoped.find(params[:id])

    respond_to do |format|
      if @special_menu.update_attributes(params[:special_menu])
        format.html { 
          gflash success: 'Special menu was successfully updated.'
          redirect_to special_menus_path
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @special_menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /special_menus/1
  # DELETE /special_menus/1.json
  def destroy
    @special_menu = SpecialMenu.unscoped.find(params[:id])
    @special_menu.destroy

    respond_to do |format|
      format.html { redirect_to special_menus_url }
      format.json { head :no_content }
    end
  end
end
