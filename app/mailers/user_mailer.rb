class UserMailer < ActionMailer::Base
  default from: "msd.soft@gmail.com"
  
  def send_message(name, email, message)
    @name = name
    @email = email
    @message = message
    mail(to: "msd.soft@gmail.com", subject: "Message from Darestan Report")
  end
  
  def register_alert(name, email)
    @name = name
    @email = email
    mail(to: "msd.soft@gmail.com", subject: "Message for registration")
  end
end
