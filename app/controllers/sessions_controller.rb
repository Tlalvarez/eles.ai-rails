class SessionsController < ApplicationController
  def new
  end

  def create
    session_params = params[:session] || params
    user = User.find_by(email: session_params[:email]&.downcase)
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: "Welcome back!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: "Logged out successfully"
  end
end
