class AdminController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_admin!

  def settings
    @settings = Setting.all
    @days = %w(monday tuesday wednesday thursday friday saturday sunday)
    @media = %w(facebook instagram twitter youtube)
  end

  def save_settings
    begin
      params['setting-name'].each do |key, value|
        setting = Setting.find_or_initialize_by(name: key)
        setting.update_attributes!(value: value)
      end
      params['hours-setting'].each do |key, value|
        value = 'closed' if value.blank?
        setting = Setting.find_or_initialize_by(name: key)
        setting.update_attributes!(value: value)
      end
      params['social-setting'].each do |key, value|
        value = 'none' if value.blank?
        setting = Setting.find_or_initialize_by(name: key)
        setting.update_attributes!(value: value)
      end
      flash[:notice] = "Settings updated successfully."
    rescue => e
       flash[:alert] = "Settings were not updated. Please make sure everything is filled out and try again."
    end
    redirect_to action: :settings
  end

  def newsletter
  end

  def send_newsletter
    begin
      profiles = Profile.where(newsletter: 1)
      if profiles.blank?
        flash[:alert] = "Nobody has subscribed to the newsletter."
      else
        NewsletterMailer.newsletter_email(profiles, params[:newsletter_content].html_safe).deliver
        flash[:notice] = "Newsletter Sent Successfully"
      end
    rescue => e
      flash[:alert] = 'There was an error sending the newsletter please try again'
    end
    redirect_to action: :newsletter
  end

  private

  def authenticate_admin!
    unless admin?
      flash[:alert] = "You must be the admin to do that action!"
      redirect_to controller: :about, action: :index
    end
  end

end
