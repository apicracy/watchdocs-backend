module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :authenticate_user!
      load_and_authorize_resource except: [:index, :documentation, :create]

      def create
        project = Project.new(create_project_params)
        authorize! :create, project
        project.generate_api_credentials
        begin
          CreateProjectInReportsService.new(project).call
          project.save
        rescue ReportsServiceError => e
          project.errors.add(:name, e.message)
        end
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
        @project = Project.find(params[:id])
        authorize! :read, @project
        render json: ProjectDocumentationSerializer.new(@project).to_json
      end

      private

      def create_project_params
        params.permit(
          :name,
          :base_url
        ).merge(user: current_user)
      end
    end
  end
end
