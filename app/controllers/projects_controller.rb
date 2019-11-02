# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :find_project, only: %i[show update destroy]

  def index
    resources = current_user.projects
    render json: ProjectSerializer.new(resources).serialized_json, status: :ok
  end

  def create
    resource = Project.new(permitted_params)
    resource.user = current_user

    if resource.save
      render json: ProjectSerializer.new(resource).serialized_json, status: :created
    else
      render json: resource.errors.to_json, status: :unprocessable_entity
    end
  end

  def show
    render json: ProjectSerializer.new(@resource).serialized_json, status: :ok
  end

  def update
    if @resource.update(permitted_params)
      render json: ProjectSerializer.new(@resource).serialized_json, status: :ok
    else
      render json: @resource.errors.to_json, status: :unprocessable_entity
    end
  end

  def destroy
    render json: ProjectSerializer.new(@resource).serialized_json, status: :ok if @resource.destroy
  end

  private

  def find_project
    @resource = current_user.projects.find_by(id: params[:id])
    render(status: :not_found) && return unless @resource
  end

  def permitted_params
    params.dig(:project).permit(:name)
  end
end
