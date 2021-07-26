class UsersController < ApplicationController
  before_action :find_user_by_provider_and_uid

  def edit; end

  def update
    if @user.update(email: params[:email])
      @user.send_confirmation_instructions
      redirect_to root_path, notice: t("devise.registrations.signed_up_but_unconfirmed")
    else
      flash[:errors] = @user.errors.full_messages
      render :edit
    end
  end

  private

  def find_user_by_provider_and_uid
    @user = Authorization.find_by!(provider: params[:provider], uid: params[:uid]).user
  end
end
