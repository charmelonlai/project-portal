class UserMailer < ActionMailer::Base
  default from: "support@projectportal.com"

  def project_approved(project, comment, status)
    @project = project
    @comment = comment
    @user = Client.find(project.client_id).user
    mail(:to => @user.email, :subject => status == 'true' ? "[Project Portal] Your project has been approved!" : "[Project Portal] Project follow-up")
  end

  def favorited_project(project, current_user)
    @project = project
    @proj_owner = User.find_by_id(@project.user_id)
    @favoriter = current_user
    mail(:to => @proj_owner.email, :subject => "[Project Portal] A User has favorited your project")
  end

  def resolution_submitted(issue, current_user)
    @issue = issue
    @proj_owner = @issue.project.user
    @submitter = current_user
    mail(:to => @proj_owner.email, :subject => "[Project Portal] An issue resolution requires your approval")
  end

  def resolution_approved(issue, submitter_id)
    @issue = issue
    @submitter = User.find_by_id(submitter_id)
    mail(:to => @submitter.email, :subject => "[Project Portal] Your Resolution to an issue has been accepted")
  end

  def resolution_denied(issue, submitter_id)
    @issue = issue
    @submitter = User.find_by_id(submitter_id)
    mail(:to => @submitter.email, :subject => "[Project Portal] Resolution follow-up")  
  end

end
