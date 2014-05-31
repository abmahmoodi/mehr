require 'open-uri'

class MailerController < ApplicationController
  def sendmail
    web_contents  = open(params[:url]) {|f| f.read }
    UserMailer.send_webpage('msd.soft@gmail.com', web_contents).deliver
    render text: 'OK'
  end
end
