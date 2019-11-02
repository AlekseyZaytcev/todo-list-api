# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  include Docs::V1::Tasks::Api

  let(:user)    { create(:user) }
  let(:project) { create(:project, user: user) }

  describe '# GET /projects/:project_id/tasks' do
    include Docs::V1::Tasks::Index

    let!(:tasks) { create_list(:task, 3, project: project) }

    context 'valid request' do
      before do
        create(:task)
        get "/projects/#{project.id}/tasks", headers: auth_headers(user)
      end

      it 'returns user tasks for current project', :dox do
        expect(response).to have_http_status(:ok)
      end

      it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      it do
        expect(response.body).to include_json(
          'data' => [
            {
              'id' => tasks[0].id.to_s,
              'type' => 'task',
              'attributes' => {
                'name' => tasks[0].name,
                'deadline' => tasks[0].deadline.as_json,
                'completed' => tasks[0].completed,
                'priority' => tasks[0].priority
              },
              'relationships' => {
                'project' => {
                  'data' => {
                    'id' => project.id.to_s,
                    'type' => 'project'
                  }
                }
              }
            },
            {
              'id' => tasks[1].id.to_s,
              'type' => 'task',
              'attributes' => {
                'name' => tasks[1].name,
                'deadline' => tasks[1].deadline.as_json,
                'completed' => tasks[1].completed,
                'priority' => tasks[1].priority
              },
              'relationships' => {
                'project' => {
                  'data' => {
                    'id' => project.id.to_s,
                    'type' => 'project'
                  }
                }
              }
            },
            {
              'id' => tasks[2].id.to_s,
              'type' => 'task',
              'attributes' => {
                'name' => tasks[2].name,
                'deadline' => tasks[2].deadline.as_json,
                'completed' => tasks[2].completed,
                'priority' => tasks[2].priority
              },
              'relationships' => {
                'project' => {
                  'data' => {
                    'id' => project.id.to_s,
                    'type' => 'project'
                  }
                }
              }
            }
          ]
        )
      end
    end

    context 'invalid request' do
      before { get "/projects/#{project.id}/tasks", headers: default_headers }

      it_behaves_like('respond unauthorized')
    end
  end

  describe '# POST /projects/:project_id/tasks' do
    include Docs::V1::Tasks::Create

    let(:attributes) { attributes_for(:task).slice(:name, :deadline) }

    context 'valid request' do
      before { post "/projects/#{project.id}/tasks", params: { task: attributes }.to_json, headers: auth_headers(user) }

      it 'creates task', :dox do
        expect(response).to have_http_status(:created)
      end

      it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      it do
        expect(response.body).to include_json(
          'data' => {
            'id' => Task.find_by(project_id: project.id, name: attributes[:name]).id.to_s,
            'type' => 'task',
            'attributes' => {
              'name' => attributes[:name],
              'deadline' => attributes[:deadline].as_json,
              'completed' => false,
              'priority' => 0
            },
            'relationships' => {
              'project' => {
                'data' => {
                  'id' => project.id.to_s,
                  'type' => 'project'
                }
              }
            }
          }
        )
      end
    end

    context 'invalid request' do
      before { post "/projects/#{project.id}/tasks", headers: default_headers }

      it_behaves_like('respond unauthorized')
    end
  end

  describe '# GET /projects/:project_id/tasks/:id' do
    include Docs::V1::Tasks::Show

    let(:task) { create(:task, project: project) }

    context 'valid request' do
      before { get "/projects/#{project.id}/tasks/#{task.id}", headers: auth_headers(user) }

      it 'returns user task for current project', :dox do
        expect(response).to have_http_status(:ok)
      end

      it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      it do
        expect(response.body).to include_json(
          'data' => {
            'id' => task.id.to_s,
            'type' => 'task',
            'attributes' => {
              'name' => task.name,
              'deadline' => task.deadline.as_json,
              'completed' => task.completed,
              'priority' => task.priority
            },
            'relationships' => {
              'project' => {
                'data' => {
                  'id' => project.id.to_s,
                  'type' => 'project'
                }
              }
            }
          }
        )
      end
    end

    context 'invalid request' do
      context 'when task not exists for this project' do
        let(:task) { create(:task) }

        before { get "/projects/#{project.id}/tasks/#{task.id}", headers: auth_headers(user) }

        it { expect(response).to have_http_status(:not_found) }
      end

      context 'when user unauthorized' do
        before { get "/projects/#{project.id}/tasks/#{task.id}", headers: default_headers }

        it_behaves_like('respond unauthorized')
      end
    end
  end

  describe '# PATCH /projects/:project_id/tasks/:id' do
    include Docs::V1::Tasks::Update

    let(:task) { create(:task, project: project) }

    context 'valid request' do
      let(:attributes) { attributes_for(:task).slice(:name, :deadline) }
      let(:params) { { task: attributes }.to_json }

      before { patch "/projects/#{project.id}/tasks/#{task.id}", params: params, headers: auth_headers(user) }

      it 'updates user task for current project', :dox do
        expect(response).to have_http_status(:ok)
      end

      it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      it do
        expect(response.body).to include_json(
          'data' => {
            'id' => task.id.to_s,
            'type' => 'task',
            'attributes' => {
              'name' => attributes[:name],
              'deadline' => attributes[:deadline].as_json,
              'completed' => task.completed,
              'priority' => task.priority
            },
            'relationships' => {
              'project' => {
                'data' => {
                  'id' => project.id.to_s,
                  'type' => 'project'
                }
              }
            }
          }
        )
      end
    end

    context 'invalid request' do
      context 'when task not exists for this project' do
        let(:task) { create(:task) }

        before { patch "/projects/#{project.id}/tasks/#{task.id}", headers: auth_headers(user) }

        it { expect(response).to have_http_status(:not_found) }
      end

      context 'when user tries to update name with existing task name' do
        let(:another_task) { create(:task, project: project) }
        let(:params)       { { task: { name: another_task.name } }.to_json }

        before { patch "/projects/#{project.id}/tasks/#{task.id}", params: params, headers: auth_headers(user) }

        it { expect(response).to have_http_status(:unprocessable_entity) }
      end

      context 'when user unauthorized' do
        before { patch "/projects/#{project.id}/tasks/#{task.id}", headers: default_headers }

        it_behaves_like('respond unauthorized')
      end
    end
  end

  describe '# DELETE /projects/:project_id/tasks/:id' do
    include Docs::V1::Tasks::Destroy

    let(:task) { create(:task, project: project) }

    context 'valid request' do
      before { delete "/projects/#{project.id}/tasks/#{task.id}", headers: auth_headers(user) }

      it 'deletes user task for current project', :dox do
        expect(response).to have_http_status(:ok)
      end

      it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      it do
        expect(response.body).to include_json(
          'data' => {
            'id' => task.id.to_s,
            'type' => 'task',
            'attributes' => {
              'name' => task.name,
              'deadline' => task.deadline.as_json,
              'completed' => task.completed,
              'priority' => task.priority
            },
            'relationships' => {
              'project' => {
                'data' => {
                  'id' => project.id.to_s,
                  'type' => 'project'
                }
              }
            }
          }
        )
      end
    end

    context 'invalid request' do
      context 'when task not exists for this project' do
        let(:task) { create(:task) }

        before { delete "/projects/#{project.id}/tasks/#{task.id}", headers: auth_headers(user) }

        it { expect(response).to have_http_status(:not_found) }
      end

      context 'when user unauthorized' do
        before { delete "/projects/#{project.id}/tasks/#{task.id}", headers: default_headers }

        it_behaves_like('respond unauthorized')
      end
    end
  end

  describe '# PATCH /tasks/:id/complete' do
    include Docs::V1::Tasks::Complete

    let(:task) { create(:task, completed: false, project: project) }

    context 'valid request' do
      before { patch "/tasks/#{task.id}/complete", params: {}, headers: auth_headers(user) }

      it 'marks user task as completed', :dox do
        expect(response).to have_http_status(:ok)
      end

      it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      it do
        expect(response.body).to include_json(
          'data' => {
            'id' => task.id.to_s,
            'type' => 'task',
            'attributes' => {
              'name' => task.name,
              'deadline' => task.deadline.as_json,
              'completed' => true,
              'priority' => task.priority
            },
            'relationships' => {
              'project' => {
                'data' => {
                  'id' => project.id.to_s,
                  'type' => 'project'
                }
              }
            }
          }
        )
      end
    end

    context 'invalid request' do
      context 'when task not exists' do
        let(:task) { create(:task) }

        before { patch "/tasks/#{task.id}/complete", headers: auth_headers(user) }

        it { expect(response).to have_http_status(:not_found) }
      end

      context 'when user unauthorized' do
        before { patch "/tasks/#{task.id}/complete", headers: default_headers }

        it_behaves_like('respond unauthorized')
      end
    end
  end

  describe '# PATCH /tasks/:id/priority' do
    include Docs::V1::Tasks::UpdatePriority

    let(:task)       { create(:task, project: project) }
    let(:attributes) { attributes_for(:task) }
    let(:params)     { { task: attributes.slice(:priority) }.to_json }

    context 'valid request' do
      before { patch "/tasks/#{task.id}/priority", params: params, headers: auth_headers(user) }

      it 'updates user task priority', :dox do
        expect(response).to have_http_status(:ok)
      end

      it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      it do
        expect(response.body).to include_json(
          'data' => {
            'id' => task.id.to_s,
            'type' => 'task',
            'attributes' => {
              'name' => task.name,
              'deadline' => task.deadline.as_json,
              'completed' => task.completed,
              'priority' => attributes[:priority]
            },
            'relationships' => {
              'project' => {
                'data' => {
                  'id' => project.id.to_s,
                  'type' => 'project'
                }
              }
            }
          }
        )
      end
    end

    context 'invalid request' do
      context 'when task not exists' do
        let(:task) { create(:task) }

        before { patch "/tasks/#{task.id}/priority", params: params, headers: auth_headers(user) }

        it { expect(response).to have_http_status(:not_found) }
      end

      context 'when user unauthorized' do
        before { patch "/tasks/#{task.id}/priority", params: params, headers: default_headers }

        it_behaves_like('respond unauthorized')
      end
    end
  end
end
