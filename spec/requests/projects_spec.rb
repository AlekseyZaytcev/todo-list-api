# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  include Docs::V1::Projects::Api

  let(:user) { create(:user) }

  describe '# GET /projects' do
    include Docs::V1::Projects::Index

    let!(:projects) { create_list(:project, 3, user: user) }

    context 'valid request' do
      before do
        create(:project)
        get '/projects', headers: auth_headers(user)
      end

      it 'returns user projects', :dox do
        expect(response).to have_http_status(:ok)
      end

      it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      it do
        expect(response.body).to include_json(
          'data' => [
            {
              'id' => projects[0].id.to_s,
              'type' => 'project',
              'attributes' => {
                'name' => projects[0].name
              },
              'relationships' => {
                'user' => {
                  'data' => {
                    'id' => user.id.to_s,
                    'type' => 'user'
                  }
                }
              }
            },
            {
              'id' => projects[1].id.to_s,
              'type' => 'project',
              'attributes' => {
                'name' => projects[1].name
              },
              'relationships' => {
                'user' => {
                  'data' => {
                    'id' => user.id.to_s,
                    'type' => 'user'
                  }
                }
              }
            },
            {
              'id' => projects[2].id.to_s,
              'type' => 'project',
              'attributes' => {
                'name' => projects[2].name
              },
              'relationships' => {
                'user' => {
                  'data' => {
                    'id' => user.id.to_s,
                    'type' => 'user'
                  }
                }
              }
            }
          ]
        )
      end
    end

    context 'invalid request' do
      before { get '/projects', headers: default_headers }

      it_behaves_like('respond unauthorized')
    end
  end

  describe '# POST /projects' do
    include Docs::V1::Projects::Create

    let(:attributes) { attributes_for(:project, user_id: user.id) }

    context 'valid request' do
      before { post '/projects', params: { project: attributes }.to_json, headers: auth_headers(user) }

      it 'creates project', :dox do
        expect(response).to have_http_status(:created)
      end

      it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      it do
        expect(response.body).to include_json(
          'data' => {
            'id' => Project.last.id.to_s,
            'type' => 'project',
            'attributes' => {
              'name' => attributes[:name]
            },
            'relationships' => {
              'user' => {
                'data' => {
                  'id' => user.id.to_s,
                  'type' => 'user'
                }
              }
            }
          }
        )
      end
    end

    context 'invalid request' do
      before { post '/projects', headers: default_headers }

      it_behaves_like('respond unauthorized')
    end
  end

  describe '# GET /projects/:id' do
    include Docs::V1::Projects::Show

    let(:project) { create(:project, user: user) }

    context 'valid request' do
      before { get "/projects/#{project.id}", headers: auth_headers(user) }

      it 'returns user project', :dox do
        expect(response).to have_http_status(:ok)
      end

      it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      it do
        expect(response.body).to include_json(
          'data' => {
            'id' => project.id.to_s,
            'type' => 'project',
            'attributes' => {
              'name' => project.name
            },
            'relationships' => {
              'user' => {
                'data' => {
                  'id' => user.id.to_s,
                  'type' => 'user'
                }
              }
            }
          }
        )
      end
    end

    context 'invalid request' do
      context 'when project not exists for this user' do
        let(:project) { create(:project) }
        before { get "/projects/#{project.id}", headers: auth_headers(user) }

        it { expect(response).to have_http_status(:not_found) }
      end

      context 'when user unauthorized' do
        before { get "/projects/#{project.id}", headers: default_headers }

        it_behaves_like('respond unauthorized')
      end
    end
  end

  describe '# PATCH /projects/:id' do
    include Docs::V1::Projects::Update

    let(:project) { create(:project, user: user) }

    context 'valid request' do
      let(:attributes) { attributes_for(:project, user_id: user.id) }

      before { patch "/projects/#{project.id}", params: { project: attributes }.to_json, headers: auth_headers(user) }

      it 'updates user project', :dox do
        expect(response).to have_http_status(:ok)
      end

      it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      it do
        expect(response.body).to include_json(
          'data' => {
            'id' => project.id.to_s,
            'type' => 'project',
            'attributes' => {
              'name' => attributes[:name]
            },
            'relationships' => {
              'user' => {
                'data' => {
                  'id' => user.id.to_s,
                  'type' => 'user'
                }
              }
            }
          }
        )
      end
    end

    context 'invalid request' do
      context 'when project not exists for this user' do
        let(:project) { create(:project) }
        before { patch "/projects/#{project.id}", headers: auth_headers(user) }

        it { expect(response).to have_http_status(:not_found) }
      end

      context 'when user tries to update name with existing project name' do
        let(:another_project) { create(:project, user: user) }
        let(:params)          { { project: { name: another_project.name } }.to_json }

        before { patch "/projects/#{project.id}", params: params, headers: auth_headers(user) }

        it { expect(response).to have_http_status(:conflict) }
      end

      context 'when user unauthorized' do
        before { patch "/projects/#{project.id}", headers: default_headers }

        it_behaves_like('respond unauthorized')
      end
    end
  end

  describe '# DELETE /projects/:id' do
    include Docs::V1::Projects::Destroy

    let(:project) { create(:project, user: user) }

    context 'valid request' do
      before { delete "/projects/#{project.id}", headers: auth_headers(user) }

      it 'deletes user project', :dox do
        expect(response).to have_http_status(:ok)
      end

      it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      it do
        expect(response.body).to include_json(
          'data' => {
            'id' => project.id.to_s,
            'type' => 'project',
            'attributes' => {
              'name' => project.name
            },
            'relationships' => {
              'user' => {
                'data' => {
                  'id' => user.id.to_s,
                  'type' => 'user'
                }
              }
            }
          }
        )
      end
    end

    context 'invalid request' do
      context 'when project not exists for this user' do
        let(:project) { create(:project) }
        before { delete "/projects/#{project.id}", headers: auth_headers(user) }

        it { expect(response).to have_http_status(:not_found) }
      end

      context 'when user unauthorized' do
        before { delete "/projects/#{project.id}", headers: default_headers }

        it_behaves_like('respond unauthorized')
      end
    end
  end
end
