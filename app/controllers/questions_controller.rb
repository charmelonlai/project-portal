class QuestionsController < ApplicationController
  before_filter :require_organization
  
  def require_organization
    if is_organization?
      if ["destroy", "update", "edit"].include? params[:action]
        q = Question.find_by_id(params[:id])
        if !q || q.organization != current_rolable
          redirect_to dashboard_path, notice: "You do not have the right permissions to view this page."
        end
      end
    else
      if user_signed_in?
        redirect_to dashboard_path, notice: "You do not have the right permissions to view this page."
      else
        redirect_to new_user_session_path, notice: "Please log in."
      end
    end
  end

  def index
    @questions = current_rolable.questions
    @question = Question.new
  end

  def edit
    @question = Question.find(params[:id])
  end

  def create
    @question = Question.new(params[:question])
    if @question.save
      current_rolable.questions << @question
      flash[:notice] = 'Question was successfully created.'
      redirect_to action: "index"
    else
      render action: "new"
    end
  end

  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(params[:question])
      flash[:notice] = 'Question was successfully updated.'
      redirect_to action: "index"
    else
      render action: "edit"
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.delete
    redirect_to action: "index"
  end

end
