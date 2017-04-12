module Api
  module V1
    class ProjectsController < ApplicationController
      def index
        authorize! :index, Project
        @projects = current_user.projects
        render json: @projects
      end
    end
  end
end
