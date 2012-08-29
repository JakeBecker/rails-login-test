class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    user = User.from_facebook_auth(request.env["omniauth.auth"])
    if user.new_record?
      session["devise.user_attributes"] = user.attributes
      flash[:info] = "Set a password to finish signing up."
      redirect_to new_user_registration_url
      else
        user.save
        flash.notice = "Signed in!" if user.active_for_authentication?
        sign_in_and_redirect user
    end
  end
end
