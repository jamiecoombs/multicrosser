class PageController < ApplicationController
  def index
    @series_with_crosswords = Series.get_all
    @room = params[:room]
    @participant = params[:participant] || 'Guest'
  end
end
