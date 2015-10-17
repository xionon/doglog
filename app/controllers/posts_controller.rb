class PostsController < ApplicationController
  def create
    dog = current_user.dogs.find(params[:dog_id])
    dog.posts.create(post_params)

    redirect_to dog_path(dog)
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end
end
