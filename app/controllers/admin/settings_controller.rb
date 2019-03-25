class SettingsController < ProtectForgeryApplication
  before_action  :authenticate_user!

  before_action :require_admin

  def index
    @setting = Setting.first || Setting.new
    @admin_theme_setting = Setting.admin
    @client_theme_setting = Setting.client
  end

  def create
    @setting = Setting.first || Setting.new
    @setting.attributes= setting_params
    @setting.save

    Setting['application_name'] = params['application_name']
    Setting['news_limit'] = params['news_limit']
    Setting['spreadsheet_limit'] = params['spreadsheet_limit'] if params[:spreadsheet_limit].to_i < 50
    Setting['email_from'] = params['email_from']
    Setting['format_date'] = params['format_date']
    redirect_to settings_path
  end

  def set_key_providers
    ['OFFICE365', 'GOOGLE', 'FACEBOOK', 'GITHUB', 'TWITTER'].each do |provider|
      Setting["#{provider}_SECRET"] = params["#{provider.downcase}"]['secret']
      Setting["#{provider}_KEY"] = params["#{provider.downcase}"]['key']
    end
    Devise.setup do |config|
      config.omniauth :github, Setting['GITHUB_KEY'], Setting['GITHUB_SECRET'], scope: 'user:email'
      config.omniauth :office365, Setting['OFFICE365_KEY'], Setting['OFFICE365_SECRET'], :scope => 'openid profile email https://outlook.office.com/mail.read'
      config.omniauth :facebook, Setting['FACEBOOK_KEY'], Setting['FACEBOOK_SECRET']
      config.omniauth :twitter, Setting['TWITTER_KEY'], Setting['TWITTER_SECRET'], scope: 'user:email'
      config.omniauth :google_oauth2, Setting['GOOGLE_KEY'],  Setting['GOOGLE_SECRET']
    end
    redirect_to settings_path
  end

  def set_notification
    EmailNotification.where.not(id: params[:notifications]).update_all(status: false)
    EmailNotification.where(id: params[:notifications]).update_all(status: true)
    redirect_to settings_path
  end

  def set_user_auth
    Setting['whitelist_ip'] = params['whitelist_ip']
    Setting['blacklist_ip'] = params['blacklist_ip']
    Setting['user_default_state'] = params['user_default_state']
    Setting['remember_for'] = params['remember_for']
    Setting['timeout_in'] = params['timeout_in']
    Setting['maximum_attempts'] = params['maximum_attempts']
    Setting['unlock_in'] = params['unlock_in']
    Setting['expire_after'] = params['expire_after']
    Devise.setup do |config|
      config.remember_for = Setting['remember_for'].to_i.weeks
      config.timeout_in = Setting['timeout_in'].to_i.minutes
      config.maximum_attempts = Setting['maximum_attempts'].to_i
      config.unlock_in = Setting['unlock_in'].to_i.hour
      config.expire_after  = Setting['expire_after'].to_i.days
    end
    redirect_to settings_path
  end

  def set_modules
    ems = EnabledModule.pluck(:name)
    rejected_modules = ems.reject{|em| params.has_key? em}
    selected_modules = ems.select{|em| params.has_key? em}
    EnabledModule.where(name: selected_modules).update_all({status: true})
    EnabledModule.where(name: rejected_modules).update_all({status: false})
    redirect_to settings_path
  end

  def set_theme
    theme = Setting.admin_theme
    hash = {
        theme_style: "#{params[:theme_style] ? params[:theme_style] : 'smart-style-0'}",
        header: "#{params[:header] ? 'fixed-header' : ''}",
        container: "#{params[:container] ? 'container' : ''}",
        footer: "#{params[:footer] ? 'fixed-page-footer' : ''}",
        topmenu: "#{params[:topmenu] ? 'menu-on-top' : '' }"
    }
    theme.value = hash.to_json
    theme.save

    theme = Setting.client_theme
    hash = {
        theme_style: "#{params[:client_theme_style] ? params[:client_theme_style] : 'smart-style-0'}",
        header: "#{params[:header] ? 'fixed-header' : ''}",
        container: "#{params[:container] ? 'container' : ''}",
        footer: "#{params[:footer] ? 'fixed-page-footer' : ''}",
        topmenu: "#{params[:topmenu] ? 'menu-on-top' : '' }"
    }
    theme.value = hash.to_json
    theme.save
    redirect_to settings_path
  end

  private

  def setting_params
    params.require(:setting).permit(:home_page_content)
  end

end
