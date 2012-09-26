class RegistrationsController < Devise::RegistrationsController
  # POST /resource
  # This is mostly copy-and-pasted from Devise's source
  def create
    build_resource

    # Jake's addition...
    if !resource.facebook_token.empty?
      graph = Koala::Facebook::API.new(resource.facebook_token)
      profile = graph.get_object("me")
      if !resource.email.nil? && resource.email == profile['email']
        resource.confirmed_at = Time.current()
      end
      #raise profile.to_yaml()
    end

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def update
    @user = User.find(current_user.id)
    email_changed = @user.email != params[:user][:email]
    password_changed = params[:user][:password] && !params[:user][:password].empty?
    successfully_updated = if password_changed
                             @user.update_with_password(params[:user])
                           else
                             @user.update_without_password(params[:user])
                           end

    if successfully_updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to user_path(current_user.id)
    else
      render "edit"
    end
  end
end