class ProjectsController < ApplicationController
  respond_to :html, :json
  before_filter :check_proposal_window, only: [:new, :create, :org_questions]

  def check_proposal_window
    redirect_to dashboard_path, notice: "The portal is currently closed to proposals." if Date.today > Rails.application.config.end_date
  end

  def new
  end

  def edit
    @project = Project.find(params[:id])
    permission_to_update(@project)
    @questions = @project.project_questions
    @emails = User.all_names_and_emails
    unless user_can_update?(@project)
      redirect_to @project, notice: 'You do not have permission to edit this project.'
    end
    @user = @project.client
  end

  def org_questions
    @project = Project.new

    if params[:project].nil?
      org_params = session[:org]
      proj_params = session[:proj]
    else
      org_params = params[:project][:organizations]
      params[:project].delete(:organizations)
      proj_params = params[:project]
    end

    session[:org] = org_params
    session[:proj] = proj_params

    @organizations = Organization.sname_hash_to_org_list(org_params)
  end

  def create
    org_params = session[:org]
    proj_params = session[:proj]

    @project = Project.new(proj_params)

    @project.client = current_rolable
    @project.organizations = Organization.sname_hash_to_org_list(org_params)

    success = @project.update_attributes(:questions => params[:project][:questions], :problem => params[:project][:problem],
      :short_description => params[:project][:short_description], :long_description => params[:project][:long_description])

    if success
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render action: "new"
    end
  end

  def show
    @project = Project.find_by_id(params[:id])
    unless @project
      redirect_to projects_path, notice: 'Nonexistent project.'
    end
  end

  def index
    if org_id = params[:organization_id]
      org = Organization.find_by_id(org_id) || Organization.find_by_sname(org_id)
      @projects = org.projects
    else
      @projects = Project.is_public
    end
    @projects = @projects.order("created_at DESC").paginate(:page => params[:page], :per_page => 8)
  end

  def search
    @projects = Project.order("created_at DESC").search(params, (user_signed_in? and current_user.admin?)).paginate(:page => params[:page], :per_page => 10)
    @title = "Search Results"
    @prev_search = params
    render :index
  end

  def update
    @project = Project.find(params[:id])

    permission_to_update(@project)

    project_params = params[:project]
    project_params.delete(:project_owner)

    if @project.approved == false
      project_params[:approved] = nil
    end

    if current_user.admin? and @project.update_attributes(project_params, :as => :admin) or @project.update_attributes(project_params, :as => :owner)
      redirect_to(@project, :notice => "Project was successfully updated.")
    else
      render action: "edit"
    end
  end

  def approval
    @project = Project.find(params[:id])
    permission_to_update(@project)
    if current_user.admin? and @project.update_attributes(params[:project], :as => :admin)
      approve_deny_project(@project)
    end
    redirect_to session[:return_to]
  end

  def public_edit
    @project = Project.find(params[:id])
    @project.update_attributes(params[:project])
    respond_with_bip(@project)
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
  end

  def edit_question
    @project = Project.find(params[:id])
    question = params[:question]
    answer = params[:project][question]
    @project.questions[question] = answer
    if @project.save
      head :ok
    else
      flash[:error] = 'Editing questions failed.'
    end
  end

  def add_org
    project = Project.find(params[:id])
    org = Organization.find(params[:org_id])
    questions = {}
    org.questions.each do |q|
      questions[Project.question_key(q).to_s] = ""
    end
    project.questions = questions
    project.organizations << org
    if project.save
      redirect_to :back
    else
    end
  end

  def remove_orgs
    project = Project.find(params[:id])
    project.questions = nil
    project.organizations = []
    if project.save
      redirect_to :back
    else
    end
  end

  private

  def approve_deny_project(project)
    comment = params[:project][:admin_note]
    enotifer_on = current_user.email_notification.proj_approval
    status = params[:project][:approved]

    flash[:notice] = status == 'true' ? "Project: '#{project.title}' was successfully approved." : "Project: '#{project.title}' was successfully denied."
    UserMailer.project_approved(project, comment, params[:project][:approved]).deliver if enotifer_on
  end

  def permission_to_update(project)
    unless user_can_update?(project)
      flash[:error] = 'You do not have permission to edit this project.'
      return redirect_to project
    end
  end

  def get_user_id_from_email(email_string)
    email = /[a-zA-Z\d-_!#\$%&'*+-\/=?^_`{.|}~]+[@]{1}+[a-zA-Z\d-]+[.]{1}[a-zA-Z]+/.match(email_string).to_s
    user = User.find_by_email(email)
    if user
      user.id
    end
  end

end
