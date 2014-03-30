class Post < ActiveRecord::Base
  attr_accessible :title, :body, :picture
  mount_uploader :picture, PictureUploader
end
