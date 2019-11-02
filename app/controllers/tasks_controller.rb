# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_task, only: %i[show update destroy]
  before_action :find_task_through_user, only: %i[complete update_priority]

  def index
    resources = current_user.projects&.find_by(id: params[:project_id])&.tasks
    render json: TaskSerializer.new(resources).serialized_json, status: :ok
  end

  def create
    resource = Task.new(permitted_params)
    resource.project_id = params[:project_id]

    if resource.save
      render json: TaskSerializer.new(resource).serialized_json, status: :created
    else
      render json: resource.errors.to_json, status: :unprocessable_entity
    end
  end

  def show
    render json: TaskSerializer.new(@resource).serialized_json, status: :ok
  end

  def update
    if @resource.update(permitted_params)
      render json: TaskSerializer.new(@resource).serialized_json, status: :ok
    else
      render json: @resource.errors.to_json, status: :unprocessable_entity
    end
  end

  def destroy
    render json: TaskSerializer.new(@resource).serialized_json, status: :ok if @resource.destroy
  end

  def complete
    @resource.update(completed: true) unless @resource.completed?
    render json: TaskSerializer.new(@resource).serialized_json, status: :ok
  end

  def update_priority
    @resource.update(priority: permitted_params[:priority])
    render json: TaskSerializer.new(@resource).serialized_json, status: :ok
  end

  private

  def find_task
    @resource = current_user.projects.find_by(id: params[:project_id])&.tasks&.find_by(id: params[:id])
    render(status: :not_found) && return unless @resource
  end

  def find_task_through_user
    @resource = current_user.tasks.find_by(id: params[:id])
    render(status: :not_found) && return unless @resource
  end

  def permitted_params
    params.dig(:task).permit(:name, :deadline, :priority)
  end
end
