class Post < ActiveRecord::Base
  belongs_to :dog

  scope :most_recent_first, -> { order(:created_at => :desc) }
end
