class IssuesController < ApplicationController
  respond_to :html, :json


  def index
    #define the page to view
    if params[:pageNum] == nil or Integer(params[:pageNum]) < 2
      @page = 1 
    else
      @page = Integer(params[:pageNum])
    end

    if params[:search_string].nil? and params[:project].nil?
      #retrieve issues that need to be displayed according to search params
      @openIssues = Issue.find(:all, :limit => 5,:offset => 5*(@page-1), :conditions => ["resolved = ?", 0], :order => "created_at")
      count = Issue.find(:all, :conditions => ["resolved = ?", 0]).size
    elsif params[:project].nil?
      @openIssues = Issue.search(params[:search_string]).find(:all, :limit => 5,:offset => 5*(@page-1), :conditions => ["resolved = ?", 0], :order => "created_at")
      count = Issue.search(params[:search_string]).find(:all, :conditions => ["resolved = ?", 0]).size
    elsif params[:search_string].nil?
      project = Project.find(params[:project])
      @openIssues = Issue.find(:all, :limit => 5,:offset => 5*(@page-1), :conditions => ["resolved = ? and project_id = ?", params[:resolved],project.id], :order => "created_at")
      count = Issue.find(:all, :conditions => ["resolved = ? and project_id = ?", params[:resolved],project.id]).size
    else
      project = Project.find(params[:project])
      @openIssues = Issue.search(params[:search_string]).find(:all, :limit => 5,:offset => 5*(@page-1), :conditions => ["resolved = ? and project_id = ?", params[:resolved],project.id], :order => "created_at")
      count = Issue.search(params[:search_string]).find(:all, :conditions => ["resolved = ? and project_id = ?", params[:resolved],project.id]).size
    end


    #set up range for pagination
    @start = @page - 2
    if @start < 1
      @start = 1
    end
    totalPages = (count / 5.0).ceil
    @end = @start + 5
    if @end > totalPages
      @end = totalPages+1
      while @end - @start != 5 and @start > 1
        @start = @start -1
      end
    end
  end

    #displays a specfic issue 
  def show
    @issue = Issue.find(params[:id])
    #check if you can edit the issue
    @project = Project.find(params[:project_id])
    @canEdit = isOwner(@project)
    #where to redirect to
    session[:return_to] ||= request.referer
  end

  def new
    if not user_signed_in?
      redirect_to new_user_session_path, notice: "You must be logged in to create an issue."
    end
    @title = "Create an Issue"
    @issue = Issue.new
  end

  #actually creates a new issue
  def create
    @issue = Issue.new(params[:id])
    project = Project.find(params[:project_id])
    @issue.project_id = project.id
    @issue.resolved = 0
    @issue.title = params[:issue][:title]
    @issue.description = params[:issue][:description]

    if @issue.save
      flash[:notice] = "Your Issue was Added"
      redirect_to(:controller => "projects", :action => 'show', :id => project)
    else
      flash[:error] = "Error in Saving. Please retry."
      render action: "new"
    end
  end

  #saves the changes
  def update
    @issue = Issue.find(params[:id])
    respond_to do |format|
      if @issue.update_attributes(params[:issue])
        format.html { redirect_to(@issue, :notice => 'User was successfully updated.') }
        format.json { respond_with_bip(@issue) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@issue) }
      end
    end
  end

  #when someone submits a solution to a Issue
  def resolve
    @issue = Issue.find(params[:id])
    @project = Project.find(@issue.project_id) 

    issue_save = @issue.update_attributes(:resolved => 1, :authors => params[:solution][:author], :github => params[:solution][:github], :submitter_id => current_user.id)
    
    # update latest repo for the project
    proj_save = @project.update_attributes(:github_site => params[:solution][:github])
    if proj_save && issue_save
      flash[:notice] = "Your Solution was Submitted"
    else
      flash[:error] = "Error in Saving. Please retry."
    end
    redirect_to project_issue_path(@project.slug, @issue.id)
    UserMailer.resolution_submitted(@issue, current_user).deliver if current_user.email_notification.issues_approval
  end

  #when the company accepts a solution to the issue
  def accept
    @issue = Issue.find(params[:id])
    @issue.resolved = 2
    project = Project.find(@issue.project_id)
    if @issue.save
      flash[:notice] = "The Solution was Accepted"
      UserMailer.resolution_approved(@issue, @issue.submitter_id).deliver
    else
      flash[:error] = "Error in Saving. Please retry."
    end
    redirect_to project_issue_path(project.slug, @issue.id)
  end

  #when the company denys a solution to the issue
  def deny
    @issue = Issue.find(params[:id])
    @issue.resolved = 0
    old_submitter = @issue.submitter_id
    @issue.submitter_id = nil
    project = Project.find(@issue.project_id)
    if @issue.save
      flash[:warning] = "The Solution was Rejected"
      UserMailer.resolution_denied(@issue, old_submitter).deliver
    else
      flash[:error] = "Error in Saving. Please retry."
    end
    redirect_to project_issue_path(project.slug,@issue.id)
  end

  def destroy
    @issue = Issue.find(params[:id])
    project = Project.find(@issue.project_id)
    @issue.destroy
    flash[:notice] = "The Issue was Deleted"
    redirect_to(:controller => "projects", :action => 'show', :id => project.slug)
  end

  def isOwner(project)
    return user_signed_in? and (current_user.admin? or (project.user_id and current_user.id == project.user.id))
  end

end
