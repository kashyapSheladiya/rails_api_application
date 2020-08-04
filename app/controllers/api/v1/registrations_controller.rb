class Api::V1::RegistrationsController < Devise::RegistrationsController
  before_action :check_user_params_present, only: :create
  # sign up
  def create
    user = User.new user_params

    if user.save
      render json: {
        messages: "Signed Up Successfully",
        is_success: true,
        data: {
          user: user
        }
      }, status: :ok
    else
      render json: {
        messages: "Something went wrong",
        is_success: false,
        data: {}
      }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def check_user_params_present
    return if params[:user].present?
    render json: {
      messages: "Parameter missing",
      is_success: false,
      data: {}
    }, status: :bad_request
  end
end