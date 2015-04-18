class UserMailer < ActionMailer::Base
  default from: "support@projectportal.com"

  def project_approved(project, comment, status)
    @project = project
    @comment = comment
    @user = Client.find(project.client_id).user
    mail(:to => @user.email, :subject => status == 'true' ? "[Project Portal] Your project has been approved!" : "[Project Portal] Project follow-up")
  end

end
