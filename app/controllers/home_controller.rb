class HomeController < ApplicationController
  def index
    @featured_posts = Post.featured.sample(10)
  end
end
