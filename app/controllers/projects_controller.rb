# frozen_string_literal: true

# All of the logic for the projects.
# URL: /projects
class ProjectsController < ApplicationController
  include ProjectAware

  before_action :authenticate_user!

  # @return [void]
  def index
    @projects = Project.includes(:primary_language).where(user_id: current_user.id)
  end

  def new
    @project = Project.new
  end

  def edit; end

  def update
    if @project.update(project_params)
      redirect_to projects_path
    else
      respond_with @project, status: :unprocessable_entity
    end
  end

  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id

    if @project.save
      redirect_to projects_path
    else
      respond_with @project, status: :unprocessable_entity
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :primary_language_id, language_ids: [])
  end
end
