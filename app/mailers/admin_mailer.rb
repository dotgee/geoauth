class AdminMailer < ApplicationMailer
  default from: ENV['default_mail_sender']

  def new_registration(user)
    @user = user
    @url = edit_admin_user_url(@user, only_path: false)
    mail(to: Settings.administrator_emails, subject: "Approbation d'un compte utilisateur: #{@user.email}")
  end
end
