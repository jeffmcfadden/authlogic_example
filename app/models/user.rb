class User < ActiveRecord::Base
 
  attr_accessible :email, :password, :password_confirmation, :openid_identifier
  
 
  acts_as_authentic do |c|
      c.validates_length_of_password_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
      c.validates_length_of_password_confirmation_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
  end
  
  
  
  # we need to make sure that either a password or openid gets set
  # when the user activates his account
  def has_no_credentials?
    self.crypted_password.blank? && self.openid_identifier.blank?
  end
    
  def active?
    active
  end
  
  def deliver_activation_instructions!
    reset_persistence_token!
    Notifier.deliver_activation_instructions(self)
  end

  def deliver_activation_confirmation!
    reset_persistence_token!
    Notifier.deliver_activation_confirmation(self)
  end
  
  # now let's define a couple of methods in the user model. The first
  # will take care of setting any data that you want to happen at signup
  # (aka before activation)
  def signup!(params)
    self.email = params[:user][:email]
    save_without_session_maintenance
  end

  # the second will take care of setting any data that you want to happen
  # at activation. at the very least this will be setting active to true
  # and setting a pass, openid, or both.
  def activate!(params)
    self.active = true
    self.password = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]
    #self.openid_identifier = params[:user][:openid_identifier]
    save
  end

end
