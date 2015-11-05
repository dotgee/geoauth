class AdminMailer < ApplicationMailer
  default from: 'admin@osuris.fr'

  def user_created_email(user)
    @user = user
    @url = ""
    mail(to: @user.email, subject: "Approbation d'un compte utilisateur: #{@user.email}")
  end
end
