# frozen_string_literal: true

class TranslationUploadsController < ApplicationController
  include ProjectAware

  before_action :authenticate_user!

  def create
    translation_upload = TranslationUpload.new(params.require(:translation_upload).permit(:file, :placeholder))

    if translation_upload.invalid?
      return render partial: 'form', status: :unprocessable_entity,
                    locals: { translation_upload: }
    end

    import_translations(translation_upload)

    render partial: 'form', status: :ok,
           locals: { translation_upload: TranslationUpload.new }
  end

  private

  def import_translations(translation_upload)
    project_id = @project.id
    language_id = Language.find_by(code: translation_upload.translation_code).id
    scope = translation_upload.translation_scope

    translation_upload.uploaded_content.each do |key, value|
      translation = Translation.where(project_id:, language_id:, scope:, key:).first_or_initialize
      translation.value = value
      translation.save
    end
  end
end
