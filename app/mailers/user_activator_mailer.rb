class UserActivatorMailer < ApplicationMailer 

  def activation_link(user)
    @user = user
    mail(to: @user.email, subject: "#{@user.first_name} Activate Your Account")
  end
end
