class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def show
        user = User.find_by(id: session[:user_id])
        if user
            render json: user, status: 200
        else
            render json: {}, status: 401
        end
    end

    def create 
        user = User.create(user_params)
        if user.valid?
            session[:user_id] = user.id
            render json: user, status: :created
        else
            render json: {errors: user.errors.full_messages }, status: 422
        end
    end

    private

    def user_params
        params.permit(:username, :password, :password_confirmation)
    end

    def record_not_found
        render json: {errors: user.errors.full_messages}, status: 401
    end
end
