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
end