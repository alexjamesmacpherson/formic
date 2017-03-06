class ChatsController < ApplicationController
  def update
    @chat = Chat.find(params[:id])
    @chat.read_all_for(current_user)
  end

  def send_message
    @chat = Chat.find(params[:chat_id])
    @chat.messages.create(sender: current_user, text: params[:message])
  end

  def readall
    current_user.chats.each do |c|
      c.read_all_for(current_user)
    end
  end
end
