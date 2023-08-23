# frozen_string_literal: true

# Module to populate the @project instance variable for controllers that need
# it. It will only populate if there is a `project_id` request variable. It
# will also be required that the `current_user` is the owner of the project.
module ProjectAware
  extend ActiveSupport::Concern

  # @return [Project]
  attr_accessor :project

  included do
    before_action :populate_project
  end

  private

  def populate_project
    id = params[:project_id]
    return if id.nil?

    @project = Project.includes(:primary_language, :languages).where(user_id: current_user.id).find_by(id:)

    redirect_to '/404' if @project.nil?
  end
end
