# frozen_string_literal: true

# Module to populate the @translation instance variable for controllers that
# need it. It will only populate if there is a `translation_id` request
# variable. It will also check that the translation is in the current project
# of the user.
#
# @see ProjectAware
module TranslationAware
  extend ActiveSupport::Concern

  included do
    before_action :populate_translation
  end

  private

  def populate_translation
    project_no_populated if @project.nil?

    id = params[:translation_id]
    return if id.nil?

    @translation = Translation.where(project_id: @project.id).find_by(id:)

    redirect_to '/404' if @translation.nil?
  end

  def project_no_populated
    raise %(
      `@project` is not populated. You must include the `ProjectAware` module
      in your controller before including the `TranslationAware` module.
    )
  end
end
