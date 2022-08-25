module V1
  class UsersController < ApplicationController
      before_action :authenticate, only: :login
      before_action :validate_authentication_token, except: %i[login create]

      def create
        user = User.new(user_params)
        if user.save
          render json: user.as_json(only: %i[email authentication_token]), status: :created
        else
          render json: { errors: user.errors.full_messages }, status: 422
        end
      end

      def show; end

      def update; end

      def destroy; end

      def login; end

      private    

      def user_params
        params.require(:user).permit(:name, :email, :username, :password, :authentication_token, :picture, :role)
      end
  end
end
