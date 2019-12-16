# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    callback_from :facebook
  end

  def google_oauth2
    callback_from :google
  end

  private

  def callback_from(provider)
    provider = provider.to_s
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user.persisted? #dbにあるか確認
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.capitalize)
      #先頭大文字日本語訳
      sign_in_and_redirect @user, event: :authentication
    else
      session[:nickname] = @user.nickname
      session[:email] = @user.email
      session[:password] = @user.password
      session[:provider] = @user.provider
      session[:uid] = @user.uid
      redirect_to new_user_registration_sns_path
    end
  end
end
