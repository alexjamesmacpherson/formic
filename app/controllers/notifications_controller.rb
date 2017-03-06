class NotificationsController < ApplicationController
  def update
    @notification = Notification.find(params[:id])
    if current_user?(@notification.user)
      @notification.seen = true
      @notification.save
      redirect_to @notification.link if @notification.link
    else
      redirect_to current_user
    end
  end

  def readall
    current_user.notifications.each do |n|
      n.seen = true
      n.save
    end
  end
end
