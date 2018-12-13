class UserMailer < ApplicationMailer
  default
  def welcome_email(user, host)
    @user = user
    @activation_url = user_activation_url(id: user.id, host: host)
    mail(to: @user.email,
         subject: "#{@user.first_name}, welcome to Brownfield!")
  end
end
