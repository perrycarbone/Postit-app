class SessionsController < ApplicationController
  def create
    user = User.where(username: params[:username]).first
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash['notice'] = 'You have successfully logged in.'
      redirect_to root_path
    else
      flash['error'] = "You Username or Password is incorrect."
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash['notice'] = 'You have logged out.'
    redirect_to root_path
  end
end
