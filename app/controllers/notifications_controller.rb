class NotificationsController < ApplicationController
  def update
    @notification = Notification.find(params[:id])
    @notification.seen = true
    @notification.save
    redirect_to URI.parse(@notification.link).path unless @notification.link.blank?
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
  end

  def clear
    current_user.notifications.each do |n|
      n.destroy
    end
  end
end
