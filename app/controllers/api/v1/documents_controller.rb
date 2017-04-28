module Api
  module V1
    class DocumentsController < ApplicationController
      before_action :authenticate_user!

      def create
        document = Document.new(create_document_params)
        authorize! :create, document
        document.save
        render_resource(document)
      end

      private

      def create_document_params
        params.permit(:project_id, :name)
      end
    end
  end
end
