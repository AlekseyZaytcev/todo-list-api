# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Registrations', type: :request do
  include Docs::V1::Users::Api

  let(:attributes) { attributes_for(:user) }
  let(:params) do
    {
      user: {
        username: attributes[:username],
        password: attributes[:password]
      }
    }.to_json
  end

  describe 'POST /users' do
    include Docs::V1::Users::Create

    context 'valid request' do
      before { post '/users', params: params, headers: default_headers }

      it 'creates new user record', :dox do
        expect(response).to have_http_status(:created)
      end

      it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      it do
        expect(response.body).to include_json(
          'data' => {
            'id' => User.find_by(username: attributes[:username]).id.to_s,
            'type' => 'user',
            'attributes' => {
              'username' => attributes[:username]
            }
          }
        )
      end
    end

    context 'invalid request' do
      let(:errors) { JSON.parse(response.body).dig('errors') }
      let(:expectations) do
        [
          "Username can't be blank",
          'Username is too short (minimum is 3 characters)',
          "Password can't be blank",
          'Password is the wrong length (should be 8 characters)',
          'Password must be alphanumeric'
        ]
      end

      before { post '/users', params: {}, headers: default_headers }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      it { expect(errors).to match_array(expectations) }
    end
  end

  describe 'DELETE /users' do
    include Docs::V1::Users::Destroy

    let(:user) { create(:user) }

    context 'valid request' do
      before { delete '/users', headers: auth_headers(user) }

      it 'destroys existing user record', :dox do
        expect(response).to have_http_status(:ok)
      end

      it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      it do
        expect(response.body).to include_json(
          'data' => {
            'id' => user.id.to_s,
            'type' => 'user',
            'attributes' => {
              'username' => user.username
            }
          }
        )
      end
    end

    context 'invalid request' do
      before { delete '/users', headers: default_headers }

      it_behaves_like('respond unauthorized')
    end
  end
end
