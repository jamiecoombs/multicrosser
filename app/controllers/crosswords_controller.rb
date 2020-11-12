class CrosswordsController < ApplicationController
  def show
    redirect_to room_path(
      source: params[:source],
      series: params[:series],
      identifier: params[:identifier],
      participant: params[:participant],
      room: SecureRandom.uuid
    )
  end
end
