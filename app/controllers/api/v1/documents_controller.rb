module Api
  module V1
    class DocumentsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_document, except: [:create]

      load_and_authorize_resource except: [:create]

      def create
        document = Document.new(create_document_params)
        authorize! :create, document
        document.save
        render_resource(document)
      end

      def update
        @document.update(update_document_params)
        render_resource(@document)
      end

      private

      def set_document
        @document = Document.find(params[:id])
      end

      def create_document_params
        params.permit(:project_id, :name)
      end

      def update_document_params
        params.permit(:name, :text)
      end
    end
  end
end
