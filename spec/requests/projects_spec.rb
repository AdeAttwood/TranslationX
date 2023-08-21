# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  fixtures :all

  describe 'GET /projects with no login' do
    before do
      get projects_path
    end

    it 'will return a redirect' do
      expect(response).to have_http_status(:redirect)
    end

    it 'will redirect to login' do
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'GET /projects user with no projects' do
    before do
      sign_in(users(:sayers))
      get projects_path
    end

    it 'be ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'will have a link to create your first project' do
      expect(response.body).to have_link('Create your first project')
    end
  end

  describe 'GET /projects user with projects' do
    before do
      sign_in(users(:goldie))
      get projects_path
    end

    it 'be ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'will have a link to create a new project' do
      expect(response.body).to have_link('New project')
    end
  end
end
