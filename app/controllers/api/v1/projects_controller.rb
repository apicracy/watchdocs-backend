module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :authenticate_user!
      load_and_authorize_resource except: :index

      def index
        authorize! :index, Project
        @projects = current_user.projects
        render json: @projects
      end

      def show
        render json: ProjectDetailedSerializer.new(@project).to_json
      end
    end
  end
end
