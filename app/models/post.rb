class Post < ActiveRecord::Base
  attr_accessible :title, :body, :picture
  mount_uploader :picture, PictureUploader

  DISQUS_SHORTNAME = Rails.env == "development" ? "rubywebit1".freeze : "rubywebit".freeze

  def to_param
    normalized_title = title.gsub(' ', '-')
    "#{self.id}-#{normalized_title}"
  end

  def self.random_posts
    Post.order('random()').first(5)
  end
end
