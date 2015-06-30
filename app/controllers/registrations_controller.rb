class RegistrationsController < Devise::RegistrationsController
  def create
    # require them to be CMU students

    # if (params[:user][:email].downcase.ends_with?("@andrew.cmu.edu") == false and params[:user][:email].downcase.ends_with?("@cmu.edu") == false)
    #   flash[:alert] = "You must sign up with your @andrew.cmu.edu email address."
    #   redirect_to new_user_registration_path and return
    # end

    if (params[:user][:first_name].blank? or params[:user][:last_name].blank?)
      flash[:alert] = "You must include both first name and last name."
      redirect_to new_user_registration_path and return
    end

    build_resource(sign_up_params)
    resource.first_name = params[:user][:first_name]
    resource.last_name = params[:user][:last_name]
    resource.advanced_lab = true if params[:user][:advanced_lab] == "1"

    if params[:user][:cs_advanced_section] == "1"
      resource.cs_advanced_section = true
    else
      resource.cs_advanced_section = false
    end

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
end