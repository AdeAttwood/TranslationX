# frozen_string_literal: true

# All of the logic for the translations on a project.
# URL: /projects/:project_id/translations
class TranslationsController < ApplicationController
  include ProjectAware
  include TranslationAware

  before_action :authenticate_user!
  before_action :populate_languages

  def index
    @primary_translations = primary_translations
    @other_translations = other_translations

    # sql_command = <<-SQL
    #   select target_translations.*,  primary_translations.key, 12 as language_id
    #   from
    #     (
    #       select * from translations
    #       where language_id = :target_language_id and project_id = :project_id
    #     ) as target_translations
    #     full outer join (
    #       select distinct (key), language_id from translations
    #       where project_id = :project_id and language_id = :primary_language_id
    #     ) as primary_translations on primary_translations.key = target_translations.key
    # SQL
    #
    # @thing = ActiveRecord::Base.connection.execute(
    #   ApplicationRecord.sanitize_sql([sql_command,
    #                                   { target_language_id: 12, primary_language_id: @project.primary_language_id,
    #                                     project_id: @project.id }])
    # )
  end

  def update
    if @translation.update(translation_params)
      flash.now[:success] = 'Translation updated successful.'
      render 'edit', translation: @translation
    else
      respond_with @translation, status: :unprocessable_entity
    end
  end

  def create
    @translation = Translation.new(translation_params)
    @translation.project_id = @project.id
    if @translation.save
      flash.now[:success] = 'Translation has been added'
      render 'edit', translation: @translation
    else
      respond_with @translation, status: :unprocessable_entity
    end
  end

  private

  def primary_translations
    query = Translation
            .where(project_id: @project.id)
            .where(language_id: @project.primary_language_id)
            .order(:key)
            .page(params[:page])

    query = query.where('key LIKE ?', "#{params[:key]}%") if params[:key].present?

    query
  end

  def other_translations
    Translation
      .where(project_id: @project.id)
      .where('language_id != ?', @project.primary_language_id)
      .to_h { |t| ["#{t.key}.#{t.language_id}", t] }
  end

  def populate_languages
    @languages = Language.all.to_h { |t| [t.id, t.key] }
  end

  def translation_params
    params.require(:translation).permit(:language_id, :key, :value, :scope)
  end
end
