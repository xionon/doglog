class HomeController < ApplicationController
  def index
    @featured_posts = Post.featured
  end

  def about
    expires_in 60.minutes, :public => true
  end
end
