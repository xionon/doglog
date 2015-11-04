class HomeController < ApplicationController
  layout "marketing"
  before_filter :defer_session, only: %i[index about]

  def index
    @featured_posts = Post.featured

    if user_signed_in?
      redirect_to timeline_path
    else
      fresh_when @featured_posts,
        public: true,
        must_revalidate: true,
        template: 'home/index'
    end
  end

  def about
    if Rails.env.test?
      # Rails doesn't send Set-Cookie for every request in test, but it does in dev/prod.
      session[:garbage_to_test_varnish_config] = "true"
    end

    expires_in 60.minutes, :public => true
  end
end
