class ActivationsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]

  def new
    @user = User.find_by_persistence_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @user.active?
  end

  def create
    @user = User.find(params[:id])

    raise Exception if @user.active?

    if @user.activate!(params)
      @user.deliver_activation_confirmation!
      flash[:notice] = "Your account has been activated."
      UserSession.create( @user, true)
      redirect_to account_url
    else
      render :action => :new
    end
  end
end