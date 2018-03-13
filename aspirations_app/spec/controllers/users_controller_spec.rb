require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #new' do
    it 'renders new users template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates new user' do
        post :create, params: {user: {username: 'npartovi@gmail.com', password: 'password123'}}
        expect(response).to redirect_to(goals_url)
      end
    end

    context 'with invalid params' do
      it 'creates new user' do
        post :create, params: {user: {username: 'nima@nima.com', password: ''}}
        expect(response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end

      it 'redirects back to new page' do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

end
