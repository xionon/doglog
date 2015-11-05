require_relative Rails.root + 'lib/purge'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def defer_session
    request.session_options[:defer] = true
  end

  def purge(path)
    Rails.logger.tagged "purge" do
      port = Rails.env.test? ? "4567" : "8000"
      http = Net::HTTP.new("localhost", port)
      http.request(Purge.new(path))
    end
  end
end
