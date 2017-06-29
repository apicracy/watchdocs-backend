module Api
  module V1
    class TreeItemsController < ApplicationController
      before_action :authenticate_user!
      load_and_authorize_resource

      def update
        item = MoveTreeItem.new(@tree_item, update_tree_item_params).call
        render json: ProjectTreeSerializer.new(item.itemable.project).to_json
      end

      private

      def update_tree_item_params
        params.permit(:to, :after, :before)
      end
    end
  end
end
