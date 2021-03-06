class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate

  private
  def authenticate
    if session[:user_id]
        if (User.where( :id => session[:user_id] )).present?
          @current_user = User.find session[:user_id]
        else
          session[:user_id] = nil
        end
    end

  end
end
