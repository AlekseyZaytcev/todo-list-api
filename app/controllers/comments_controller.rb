# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :find_comment, only: %i[destroy]

  def index
    resources = current_user.tasks&.find_by(id: params[:task_id])&.comments
    render json: CommentSerializer.new(resources).serialized_json, status: :ok
  end

  def create
    resource = Comment.new(permitted_params)
    resource.task_id = params[:task_id]

    if resource.save
      render json: CommentSerializer.new(resource).serialized_json, status: :created
    else
      render json: resource.errors.to_json, status: :conflict
    end
  end

  def destroy
    render json: CommentSerializer.new(@resource).serialized_json, status: :ok if @resource.destroy
  end

  private

  def find_comment
    @resource = current_user.tasks.find_by(id: params[:task_id])&.comments&.find_by(id: params[:id])
    render(status: :not_found) && return unless @resource
  end

  def permitted_params
    params.dig(:comment).permit(:body)
  end
end
