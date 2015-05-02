require 'csv'

class UserController < ApplicationController
  before_filter :require_admin, only: [:admin_dashboard, :set_date, :export_to_csv, :add_admin, :remove_admin]

  def require_admin
    if !user_signed_in?
      redirect_to new_user_session_path, notice: "Please log in."
    elsif user_signed_in? && !current_user.admin?
      redirect_to dashboard_path, notice: "You do not have the right permissions to view this page."
    end
  end

  def dashboard
    case
    when is_organization?
      organization_dashboard
    when is_client?
      client_dashboard
    when is_developer?
      developer_dashboard
    when is_admin?
      admin_dashboard
    else
      #error
    end
  end

  def admin_dashboard
    @projects = Project.order("created_at DESC")
    render(:template => 'user/admin_dashboard')
  end

  def set_date
    year = params[:dates]["end_date(1i)"].to_i
    month = params[:dates]["end_date(2i)"].to_i
    day = params[:dates]["end_date(3i)"].to_i

    begin
      end_date = Date.new(year, month, day)
      Rails.application.config.end_date = end_date
      notice = "Deadline successfully set to #{end_date.strftime("%B %-d, %Y")}."
    rescue ArgumentError => e
      notice = "Invalid date selected."
    end
    
    redirect_to admin_dashboard_path, :notice => notice
  end

  def export_to_csv
    projects = Project.order("created_at DESC")
    
    # http://stackoverflow.com/a/2473637
    csv_string = CSV.generate do |csv|
      cols = ["Project Name", "Client Email", "Short Description", "Long Description"]
      csv << cols

      projects.each do |project|
        csv << [project.title, project.client.contact_email, project.short_description, project.long_description]
      end
    end

    send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => "projects.csv")
  end

  def filter_projects
    project_type = params[:project_type]
    project_focus = params[:project_focus]

    @projects = Project.is_public

    if project_type != ''
      @projects = @projects.where("project_type = ?", project_type)
    end

    if project_focus != ''
      @projects = @projects.where("sector = ?", project_focus)
    end
      @projects = @projects.paginate(:page => params[:page], :per_page => 8)
      render(:template => 'projects/index')
  end

  def add_admin
    if params[:commit] == "Add"
      email = /[a-zA-Z\d-_!#\$%&'*+-\/=?^_`{.|}~]+[@]{1}+[a-zA-Z\d-]+[.]{1}[a-zA-Z]+/.match(params[:user]).to_s
      create_admin(email)
    elsif params[:commit] == "View All"
      view_all_admins
    end
  end
  
  def remove_admin
    @user = User.find_by_id(params[:id])
    if @user and @user.admin?
      @user.update_attributes(:admin=>false)
      redirect_to add_admin_path, notice: "#{@user.fname} #{@user.lname} is no longer an admin."
    else
      flash[:error] = "Your action is invalid."
      redirect_to user_settings_path
    end
  end

  protected
  def organization_dashboard
    @questions = current_rolable.questions
    @projects = current_rolable.projects.order("created_at DESC").paginate(:page => params[:projects_page], :per_page => 5)

    render(:template => 'user/organization_dashboard')
  end

  def client_dashboard
    @projects = current_rolable.projects.order("created_at DESC").paginate(:page => params[:projects_page], :per_page => 5)
    render(:template => 'user/client_dashboard')
  end

  def developer_dashboard
    render(:template => 'user/developer_dashboard')
  end

  def create_admin(email)
    @email = email
    @user = User.find_by_email(@email)
    notice = ''
    if @user and not @user.admin?
      @user.update_attributes(:admin=>true)
      notice = "#{@user.fname} #{@user.lname} is now an admin."
    elsif @user and @user.admin?
      notice = "#{@user.fname} #{@user.lname} is already an admin."
    else
      flash[:error] =  "#{@email} does not exist. Would you like to create a user?"
    end
    redirect_to admin_dashboard_path, notice: notice
  end

  def view_all_admins
    @all_admins = User.find_all_by_admin(true)
  end

end


# if user_signed_in?
#   @projects = Project.order("created_at DESC").paginate(:page => params[:projects_page], :per_page => 5).find_all_by_user_id(current_user.id)
#   # @favorites = current_user.favorite_projects.paginate(:page => params[:favorites_page], :per_page => 5)
# else
#   #SHOULDN'T BE ABLE TO SEE DASHBOARD IF NOT SIGNED IN IN THE FIRST PLACE--USE FILTER
#   redirect_to new_user_session_path, notice: 'Please log in to view your dashboard.'
# end
