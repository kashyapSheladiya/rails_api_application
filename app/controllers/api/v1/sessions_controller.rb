class Api::V1::SessionsController < Devise::SessionsController
  before_action :sign_in_params, only: :create
  before_action :load_user, only: :create
  before_action :valid_token, only: :destroy
  skip_before_action :verify_signed_out_user, only: :destroy

  #sign_in

  def create
    if @user.valid_password?(sign_in_params[:password])
      sign_in 'user', @user
      json_response "Successfully Signed In", true, {user: @user}, :ok
    else
      json_response "Unauthorized User", false, {}, :unauthorized
    end
  end

  #sign_out

  def destroy
    sign_out @user
    @user.generate_new_authentication_token
    json_response "Successfully Signed Out", true, {}, :ok
  end

  private
  def sign_in_params
    params.require(:sign_in).permit(:email, :password)
  end

  def load_user
    @user = User.find_for_database_authentication(email: sign_in_params[:email])
    if @user
      return @user
    else
      json_response "Cannot find User", false, {}, :failure
    end
  end

  def valid_token
    @user = User.find_by authentication_token: request.headers['AUTH-TOKEN']
    if @user
      return @user
    else
      json_response "Invalid Token", false, {}, :failure
    end
  end
end

# find_for_database_authentication(line:21) and valid_password?(line: 7) are the methods inherited from Devise,
# and can be find from devise github lib>devise>models>database_authenticable.rb

# sign_in(line: 8) is the methods inherited from Devise,
# and can be find from devise github lib>devise>controllers>sign_in_out.rb

# verify_signed_out_user(line: 5) is a method inherited from Devise, 
# It return respond_to_on_destroy, but this is API project so we have to skip it.
# and can be find from devise github app>controllers>devise>sessions_controller.rb

# sign_out(line: 21) is the methods inherited from Devise,
# and can be find from devise github lib>devise>controllers>sign_in_out.rb
