class HomeController < ApplicationController
  def index
    @featured_posts = Post.featured
  end

  def about
    if Rails.env.test?
      # Rails doesn't send Set-Cookie for every request in test, but it does in dev/prod.
      session[:garbage_to_test_varnish_config] = "true"
    end

    expires_in 60.minutes, :public => true
  end
end
