module Api
  module V1
    class DocumentsController < ApplicationController
      before_action :authenticate_user!
      load_and_authorize_resource except: [:create]

      def create
        document = Document.new(create_document_params)
        authorize! :create, document
        document.save
        render_resource(document)
      end

      def destroy
        @document.destroy
        render json: @document
      end
      
      def update
        @document.update(update_document_params)
        render_resource(@document)
      end

      private

      def create_document_params
        params.permit(:project_id, :name, :text)
      end

      def update_document_params
        params.permit(:name, :text)
      end
    end
  end
end
