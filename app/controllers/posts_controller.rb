class PostsController < ApplicationController
  before_filter :defer_session, only: %i[index show]

  def index
    @posts = current_dog.posts.most_recent_first

    expires_in 0.seconds, must_revalidate: true, "s-maxage": 10.minutes
    if stale?(@posts, public: true)
      render :layout => request.headers['X-ESI'].blank?
    end
  end

  def show
    @post = current_dog.posts.find(params[:id])

    expires_in 0.seconds, must_revalidate: true, "s-maxage": 10.minutes
    fresh_when @post, public: true
  end

  def create
    dog = current_user.dogs.find(params[:dog_id])
    dog.posts.create(post_params)

    purge(dog_posts_path(dog))

    redirect_to dog_path(dog)
  end

  private

  def current_dog
    @dog ||= Dog.where(id: params[:dog_id]).first
  end

  def post_params
    params.require(:post).permit(:body)
  end
end
