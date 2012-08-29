class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me,
      :facebook_token, :facebook_token_expires

  def self.from_facebook_auth(auth)
    #raise auth.to_yaml()
    user = where(:facebook_uid => auth.uid).first_or_initialize do |user|
      user.name = auth.info.name
      user.email = auth.info.email
    end
    user.facebook_token = auth.credentials.token
    user.facebook_token_expires = Time.at(auth.credentials.expires_at)
    return user
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
      end
    else
      super
    end
  end
end
