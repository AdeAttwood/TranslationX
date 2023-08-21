# frozen_string_literal: true

# Base controller for the application
class ApplicationController < ActionController::Base
  respond_to :html, :json
  self.responder = ApplicationResponder
end
