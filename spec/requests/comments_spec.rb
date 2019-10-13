# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  include Docs::V1::Comments::Api

  let(:user)    { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task)    { create(:task, project: project) }

  describe '# GET /tasks/:task_id/comments' do
    include Docs::V1::Comments::Index

    let!(:comments) { create_list(:comment, 3, task: task) }

    context 'valid request' do
      before do
        create(:comment)
        get "/tasks/#{task.id}/comments", headers: auth_headers(user)
      end

      it 'returns user comments for current task', :dox do
        expect(response).to have_http_status(:ok)
      end

      it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      it do
        expect(response.body).to include_json(
          'data' => [
            {
              'id' => comments[0].id.to_s,
              'type' => 'comment',
              'attributes' => {
                'body' => comments[0].body
              },
              'relationships' => {
                'task' => {
                  'data' => {
                    'id' => task.id.to_s,
                    'type' => 'task'
                  }
                }
              }
            },
            {
              'id' => comments[1].id.to_s,
              'type' => 'comment',
              'attributes' => {
                'body' => comments[1].body
              },
              'relationships' => {
                'task' => {
                  'data' => {
                    'id' => task.id.to_s,
                    'type' => 'task'
                  }
                }
              }
            },
            {
              'id' => comments[2].id.to_s,
              'type' => 'comment',
              'attributes' => {
                'body' => comments[2].body
              },
              'relationships' => {
                'task' => {
                  'data' => {
                    'id' => task.id.to_s,
                    'type' => 'task'
                  }
                }
              }
            }
          ]
        )
      end
    end

    context 'invalid request' do
      before { get "/tasks/#{task.id}/comments", headers: default_headers }

      it_behaves_like('respond unauthorized')
    end
  end

  describe '# POST /tasks/:task_id/comments' do
    include Docs::V1::Comments::Create

    let(:attributes) { attributes_for(:comment).slice(:body) }

    context 'valid request' do
      before { post "/tasks/#{task.id}/comments", params: { comment: attributes }.to_json, headers: auth_headers(user) }

      it 'creates comment', :dox do
        expect(response).to have_http_status(:created)
      end

      it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      it do
        expect(response.body).to include_json(
          'data' => {
            'id' => Comment.find_by(task_id: task.id, body: attributes[:body]).id.to_s,
            'type' => 'comment',
            'attributes' => {
              'body' => attributes[:body]
            },
            'relationships' => {
              'task' => {
                'data' => {
                  'id' => task.id.to_s,
                  'type' => 'task'
                }
              }
            }
          }
        )
      end
    end

    context 'invalid request' do
      before { post "/tasks/#{task.id}/comments", headers: default_headers }

      it_behaves_like('respond unauthorized')
    end
  end

  describe '# DELETE /tasks/:task_id/comments/:id' do
    include Docs::V1::Tasks::Destroy

    let(:comment) { create(:comment, task: task) }

    context 'valid request' do
      before { delete "/tasks/#{task.id}/comments/#{comment.id}", headers: auth_headers(user) }

      it 'deletes user comment for current tasks', :dox do
        expect(response).to have_http_status(:ok)
      end

      it { expect(response.content_type).to eq('application/json; charset=utf-8') }
      it do
        expect(response.body).to include_json(
          'data' => {
            'id' => comment.id.to_s,
            'type' => 'comment',
            'attributes' => {
              'body' => comment.body
            },
            'relationships' => {
              'task' => {
                'data' => {
                  'id' => task.id.to_s,
                  'type' => 'task'
                }
              }
            }
          }
        )
      end
    end

    context 'invalid request' do
      context 'when comment not exists for this task' do
        let(:comment) { create(:comment) }

        before { delete "/tasks/#{task.id}/comments/#{comment.id}", headers: auth_headers(user) }

        it { expect(response).to have_http_status(:not_found) }
      end

      context 'when user unauthorized' do
        before { delete "/tasks/#{task.id}/comments/#{comment.id}", headers: default_headers }

        it_behaves_like('respond unauthorized')
      end
    end
  end
end
