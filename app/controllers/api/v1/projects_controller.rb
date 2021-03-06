module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :authenticate_user!, except: [:documentation]
      load_and_authorize_resource except: [:index, :documentation, :create]

      def create
        project_creator = CreateProject.new(create_project_params)
        authorize! :create, project_creator.project
        project = project_creator.call
        render_resource(project)
      end

      def index
        authorize! :index, Project
        @projects = current_user.projects
        render json: @projects
      end

      def show
        render json: ProjectTreeSerializer.new(@project).to_json
      end

      def documentation
        @project = Project.friendly.find(params[:id])
        authenticate_user! unless @project.public
        authorize! :read_documentation, @project
        render json: ProjectDocumentationSerializer.new(@project).to_json
      end

      def update
        @project.update(update_project_params)
        render_resource(@project)
      end

      def destroy
        @project.destroy
        render_resource(@project)
      end

      private

      def create_project_params
        params.permit(
          :name,
          :base_url,
          :public
        ).merge(user: current_user)
      end

      def update_project_params
        params.permit(
          :name,
          :base_url,
          :public
        )
      end
    end
  end
end
