class StaticController < ApplicationController
  def index
    
  end

  def about

  end

  def menu

  end

  def photos

  end

  def art_club

  end

  def show_event
    @event = Event.find(params[:id])
  end

  def upcoming_events

  end

  def past_events

  end

  def press

  end

  def contact

  end

end
