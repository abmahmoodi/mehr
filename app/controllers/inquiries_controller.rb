class InquiriesController < ApplicationController
  
  def new
    @inquiry = Inquiry.new
  end
    
  def create
    @inquiry = Inquiry.new(params[:inquiry])
    if new_verify and @inquiry.deliver
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def new_verify
    # if Rails.env.development?
    #   return true
    # end

    url = URI.parse('https://www.google.com/recaptcha/api/siteverify')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    data = "secret=6LcRfv8SAAAAAE6St--SzyTnfRUDm4a1AgHN0WHf&response=#{params[:'g-recaptcha-response']}"
    headers = {'Content-Type' => 'application/x-www-form-urlencoded'}
    h = http.post(url.path, data, headers)
    res = ActiveSupport::JSON.decode(h.body)
    res['success']
  end
end