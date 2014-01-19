class Inquiry
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include ActionView::Helpers::TextHelper
  
  attr_accessor :name, :email, :message, :nickname
  
  validates :name, :email, :message, :presence => {message: 'این مقدار اجباری است.'}
  
  validates :email,
            :format => { :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ , message: 'غیر مجاز.'}
  
  validates :message, :length => { :minimum => 10, :maximum => 1000, too_short: "حداقل 10 کارکتر.",
    too_long: "حداکثر 1000 کارکتر." }
            
  validates :nickname, 
            :format => { :with => /\A\z/ }
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def deliver
    return false unless valid?
    UserMailer.send_message(name, email, simple_format(message)).deliver
=begin
    Pony.mail({
      :from => %("#{name}" <#{email}>),
      :reply_to => email,
      :subject => "Website inquiry",
      :body => message,
      :html_body => simple_format(message)
    })
=end
  end
      
  def persisted?
    false
  end
end