# frozen_string_literal: true

# Render flash messages to be displayed to the user as notifications.
#
# @example
# flash.now[:success] = 'Translation updated successful.'
class FlashComponent < ApplicationComponent
  attr_accessor :flash, :timeout

  # @param [ActionDispatch::Flash::FlashHash] flash
  # @param [Integer] timeout
  def initialize(flash:, timeout: 3000)
    super()
    @flash = flash
    @timeout = timeout
  end

  # @return [void]
  def template
    flash.each do |type, message|
      template_tag(data_notification: 'yes', timeout:) do
        div(class: %(notification #{type} mb-2)) do
          div(class: 'title') { type.titleize }
          div(class: 'message') { message }
        end
      end
    end
  end
end
