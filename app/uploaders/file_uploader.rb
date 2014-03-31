class FileUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave
  process :tags => ['product_file']

end