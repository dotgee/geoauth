class AdminMailer < ApplicationMailer
  default from: 'admin@osuris.fr'

  def user_created_email(user)
    @user = user
    @url = edit_admin_user_url(@user, only_path: false)
    mail(to: Settings.administrator_emails, subject: "Approbation d'un compte utilisateur: #{@user.email}")
  end
end
