class DogsController < ApplicationController
  before_filter :defer_session, only: %i[index show]

  def index
    @dogs = Dog.includes(:posts).all

    expires_in 0.seconds, must_revalidate: true, "s-maxage": 10.minutes
    fresh_when @dogs, public: true
  end

  def show
    @dog = Dog.find(params[:id])

    response.headers['X-ESI'] = 'true'

    expires_in 0.seconds, must_revalidate: true, "s-maxage": 10.minutes
    fresh_when @dog, public: true
  end
end
