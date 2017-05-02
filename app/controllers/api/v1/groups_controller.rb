module Api
  module V1
    class GroupsController < ApplicationController
      before_action :authenticate_user!
      load_and_authorize_resource except: [:create]

      def create
        group = Group.new(create_group_params)
        authorize! :create, group
        group.save
        render_resource(group)
      end

      def destroy
        @group.destroy
        render json: @group
      end

      private

      def create_group_params
        params.permit(:project_id, :name, :description)
      end
    end
  end
end
