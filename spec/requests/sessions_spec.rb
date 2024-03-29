# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Sessions', type: :request do
  include Docs::V1::Users::Api

  let(:user) { create(:user) }

  describe 'POST /users/sign_in' do
    include Docs::V1::Users::SignIn

    context 'valid request' do
      let(:params) do
        {
          user: {
            username: user.username,
            password: user.password
          }
        }.to_json
      end

      before { post '/users/sign_in', params: params, headers: default_headers }

      it 'creates new user session', :dox do
        expect(response).to have_http_status(:created)
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
      before { post '/users/sign_in', params: {}, headers: default_headers }

      it_behaves_like('respond unauthorized')
    end
  end

  describe 'DELETE /users' do
    include Docs::V1::Users::SignOut
    let(:headers_with_auth_token) { auth_headers(user) }

    context 'valid request' do
      before { delete '/users/sign_out', headers: headers_with_auth_token }

      it 'destroys user sessions', :dox do
        expect(response).to have_http_status(:no_content)
      end

      it 'revokes auth token' do
        delete '/users', headers: headers_with_auth_token

        expect(JSON.parse(response.body).dig('error')).to eq('revoked token')
      end
    end

    context 'invalid request' do
      before { delete '/users/sign_out', params: {}, headers: default_headers }

      it { expect(response).to have_http_status(:no_content) }
    end
  end
end
