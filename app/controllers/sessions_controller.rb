class SessionsController < ApplicationController


  def create
    user = User.where(username: params[:username]).first
    if user && user.authenticate(params[:password])
      if user.two_factor_auth?
        session[:two_factor] = true
        user.generate_pin!
        user.send_pin_to_twilio
        redirect_to pin_path
      else
        login_success!(user)
      end
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

  def pin
    access_denied if session[:two_factor].nil?

    if request.post?
      user = User.find_by(pin: params[:pin])
        if user
          session[:two_factor] = nil
          login_success!(user)
          user.remove_pin!
        else
          flash['error'] = "Something is wrong with your pin number."
          redirect_to pin_path
        end
    end
  end

  private
    def login_success!(user)
      session[:user_id] = user.id
      flash['notice'] = 'You have successfully logged in.'
      redirect_to root_path
    end
end
