class HomeController < ApplicationController
  def index
    @featured_posts = Post.limit(100).order(created_at: :desc)
  end
end
