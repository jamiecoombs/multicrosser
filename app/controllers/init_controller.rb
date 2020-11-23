class InitController < ApplicationController
  def index
    redirect_to page_url(
      room: SecureRandom.uuid
    )
  end
end
