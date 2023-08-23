# frozen_string_literal: true

class TranslationUpload
  include ActiveModel::Model

  attr_accessor :file, :placeholder

  validates :file, presence: true
  validate :validate_file_type
  validate :validate_language_code

  # @param [Hash] attributes
  def initialize(attributes = {})
    super
  end

  def translation_scope
    PATTERNS.each do |pattern|
      matches = file.original_filename.match(pattern)
      return matches[:scope] if !matches.nil? && matches.names.include?('scope')
    end

    'default'
  end

  def translation_code
    PATTERNS.each do |pattern|
      matches = file.original_filename.match(pattern)
      return matches[:code] if !matches.nil? && matches.names.include?('code')
    end

    nil
  end

  def uploaded_content
    content = YAML.load_file(file.tempfile, aliases: true)
    flatten_hash(content.key?(translation_code) ? content[translation_code] : content)
  end

  private

  SCOPE_THEN_CODE = /^(?<scope>\w+)\.(?<code>[a-zA-Z]{2}(-[a-zA-Z]{2})?)\./ # rubocop:disable Lint/MixedRegexpCaptureTypes
  CODE_THEN_SCOPE = /^(?<code>[a-zA-Z]{2}(-[a-zA-Z]{2})?)\.(?<scope>\w+)\./ # rubocop:disable Lint/MixedRegexpCaptureTypes
  CODE_ONLY = /^(?<code>[a-zA-Z]{2}(-[a-zA-Z]{2})?)\./ # rubocop:disable Lint/MixedRegexpCaptureTypes

  PATTERNS = [SCOPE_THEN_CODE, CODE_THEN_SCOPE, CODE_ONLY].freeze

  def validate_language_code
    return if file.nil?

    code = translation_code
    return errors.add :file, :missing_language_code, message: 'Language code is not found in the file name' if code.nil?

    valid_code = Language.exists?(code:)
    errors.add :file, :invalid_language_code, message: "Invalid language code '#{code}'" unless valid_code
  end

  def validate_file_type
    return if file.nil?

    errors.add :file, :invalid_type, message: 'must be a YAML file' unless file.content_type == 'application/x-yaml'
  end

  def flatten_hash(param, prefix = nil)
    param.each_pair.reduce({}) do |a, (k, v)|
      v.is_a?(Hash) ? a.merge(flatten_hash(v, "#{prefix}#{k}.")) : a.merge("#{prefix}#{k}".to_sym => v)
    end
  end
end
