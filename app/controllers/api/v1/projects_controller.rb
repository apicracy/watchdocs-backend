module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :authenticate_user!
      load_and_authorize_resource except: [:index, :documentation]

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
    end
  end
end
