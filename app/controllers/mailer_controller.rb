class MailerController < ApplicationController
  def sendmail
    UserMailer.send_webpage('msd.soft@gmail.com', 'Hello world mailing.').deliver
    render text: 'OK'
  end
end
