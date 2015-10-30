class PostsController < ApplicationController
  def show
    @posts = current_dog.posts
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
