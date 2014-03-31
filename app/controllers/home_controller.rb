class HomeController < ApplicationController
  def index
  	@recommendations = Recommendation.includes(:user)
  end
end
