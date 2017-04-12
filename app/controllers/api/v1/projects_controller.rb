module Api
  module V1
    class ProjectsController < ApplicationController
      before_filter :authenticate_user!

      def index
        authorize! :index, Project
        @projects = current_user.projects
        render json: @projects
      end
    end
  end
end
