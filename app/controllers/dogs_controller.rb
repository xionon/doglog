class DogsController < ApplicationController
  before_filter :defer_session, only: %i[index show]

  def index
    @dogs = Dog.includes(:posts).all

    fresh_when @dogs,
      public: true,
      must_revalidate: true
  end

  def show
    @dog = Dog.find(params[:id])

    response.headers['X-ESI'] = 'true'

    fresh_when @dog,
      public: true,
      must_revalidate: true
  end
end
