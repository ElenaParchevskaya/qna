module Api
  module V1
    class BaseController < ApplicationController
      before_action :doorkeeper_authorize!

      private

      def current_resource_owner
        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      alias current_user current_resource_owner

      def save_and_render(resource, success_status = :ok)
        if resource.save
          render json: resource, status: success_status
        else
          render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
