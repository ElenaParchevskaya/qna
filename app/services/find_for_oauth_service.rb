class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid)
    return authorization.user if authorization

    authorize_user
  end

  private

  def authorize_user
    email = auth.info.email || ''
    user = User.find_by(email: email) if email.present?

    User.transaction do
      user ||= create_user(email)
      user.authorizations.create!(provider: auth.provider, uid: auth.uid)
    end

    user
  end

  def create_user(email)
    password = Devise.friendly_token[0, 20]
    user = User.new(email: email, password: password, password_confirmation: password)
    if email.present?
      user.skip_confirmation!
      user.save!
    else
      user.save!(validate: false)
    end
    user
  end
end
