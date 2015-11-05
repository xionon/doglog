class PostsController < ApplicationController
  before_filter :defer_session, only: %i[show]

  def show
    @post = current_dog.posts.find(params[:id])

    fresh_when @post,
      public: true,
      must_revalidate: true
  end

  def create
    dog = current_user.dogs.find(params[:dog_id])
    dog.posts.create(post_params)

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
