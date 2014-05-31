class Mailer
  def deliver
    UserMailer.send_message('A', 'a@b.c', 'Hello').deliver
  end
end