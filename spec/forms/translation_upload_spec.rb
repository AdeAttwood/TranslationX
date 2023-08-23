# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TranslationUpload, type: :model do
  let(:model) do
    model = TranslationUpload.new(params)
    model.validate

    model
  end

  context 'with invalid file' do
    let(:params) { {} }

    it 'will not be valid' do
      expect(model).to_not be_valid
    end

    it 'will have a missing file error message' do
      expect(model.errors.full_messages_for(:file)).to eq(["File can't be blank"])
    end
  end

  context 'with invalid file' do
    let(:params) do
      { file: fixture_file_upload('empty.yml.fixture', 'application/x-yaml') }
    end

    it 'will not be valid' do
      expect(model).to_not be_valid
    end

    it 'will have a missing file error message' do
      expect(model.errors.full_messages_for(:file)).to eq(['File Language code is not found in the file name'])
    end
  end

  context 'with invalid file' do
    let(:params) do
      { file: fixture_file_upload('empty.yml.fixture', 'application/x-no-no') }
    end

    it 'will not be valid' do
      expect(model).to_not be_valid
    end

    it 'will have a missing file error message' do
      expect(model.errors.full_messages_for(:file)).to eq(['File must be a YAML file',
                                                           'File Language code is not found in the file name'])
    end
  end
end
