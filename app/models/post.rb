class Post < ActiveRecord::Base
  belongs_to :dog, touch: true

  scope :most_recent_first, -> { order(:created_at => :desc) }
  scope :featured, -> { limit(10).most_recent_first }
end
