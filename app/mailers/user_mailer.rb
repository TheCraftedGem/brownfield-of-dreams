class UserMailer < ApplicationMailer
  default from: "Brownfield@brownfield.com"

  # TODO: Add security to the activation process.
  def welcome_email(user, host)
    @user = user
    @activation_url = user_activation_url(id: user.id, host: host)
    mail(to: @user.email,
         subject: "#{@user.first_name}, welcome to Brownfield!")
  end

  def github_invite_email(invitee, sender, host)
    return :failed unless invitee[:email]
    @signup_url = new_user_url(host: host)
    @recipient = invitee[:name]
    @sender = sender[:name]
    @recipient || subject = "Join Brownfield!"
    @recipient && subject = "#{@recipient}, join Brownfield!"
    mail(to: invitee[:email], subject: subject)
  end
end
