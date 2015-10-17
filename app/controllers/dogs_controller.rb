class DogsController < ApplicationController
  def show
    @dog = Dog.includes(:posts).find(params[:id])
    @posts = @dog.posts.most_recent_first

    respond_to do |format|
      format.html
    end
  end
end
