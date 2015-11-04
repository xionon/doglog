class DogsController < ApplicationController
  before_filter :defer_session, only: %i[index show]

  def index
    @dogs = Dog.includes(:posts).all

    fresh_when @dogs, public: true
  end

  def show
    @dog = Dog.includes(:posts).find(params[:id])
    @posts = @dog.posts.most_recent_first

    fresh_when @dog, public: true
  end
end
