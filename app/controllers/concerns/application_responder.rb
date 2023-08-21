# frozen_string_literal: true

# Override to the default responder to add any custom functionality we need and
# keep all of our responses consistent.
class ApplicationResponder < ActionController::Responder
  # Override the json resource_errors method to return full error messages when
  # we are returning json from requests and the resource is not valid.
  def json_resource_errors
    { errors: resource.errors.as_json(full_messages: true) }
  end
end
