class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = FindForOauthService.new(request.env['omniauth.auth']).call
    redirect_flow(kind: "Github")
  end

  def google_oauth2
    @user = FindForOauthService.new(request.env['omniauth.auth']).call

    if @user && @user.email.blank?
      authorization = @user.authorizations.find_by!(provider: 'google_oauth2')
      return redirect_to edit_user_path(provider: 'google_oauth2', uid: authorization.uid)
    end

    redirect_flow(kind: "Google")
  end

  private

  def redirect_flow(options = {})
    kind = options[:kind] || "Test"

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind)
    else
      redirect_to root_path, alert: 'Authentication failed'
    end
  end
end
