# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlashComponent, type: :view do
  let(:flash) { ActionDispatch::Flash::FlashHash.new }
  let(:result) { Nokogiri render described_class.new(flash:) }

  context 'with success message' do
    before { flash.now[:success] = 'Whoop' }

    it 'will render a title' do
      expect(result.css('template').first.inner_html).to have_css('.title', text: 'Success')
    end

    it 'will render the message provided' do
      expect(result.css('template').first.inner_html).to have_css('.message', text: 'Whoop')
    end
  end

  context 'with error message' do
    before { flash.now[:error] = 'Nope' }

    it 'will render a title' do
      expect(result.css('template').first.inner_html).to have_css('.title', text: 'Error')
    end

    it 'will have the error class' do
      expect(result.css('.error')).not_to be_empty
    end
  end
end
