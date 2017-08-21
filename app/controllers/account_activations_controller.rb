class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    activation_token = params[:id]

    if user_and_not_activated?(user, :activation, activation_token)
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link."
      redirect_to root_url
    end
  end

  private

    def user_and_not_activated?(user, activation, activation_token)
      user && !user.activated? &&
        user.authenticated?(activation, activation_token)
    end
end
