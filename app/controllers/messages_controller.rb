class MessagesController < ApplicationController
  #before_action :logged_in_user
  before_action :get_messages

  def index
  end

  def new
    @message = Message.new
  end

  def create
    if current_user
      message = current_user.messages.build(message_params)
    else
      message = Message.new(message_params)
    end

    if message.save(validate: false)
      ActionCable.server.broadcast 'room_channel',
                                   message: render_message(message)
      message.mentions.each do |mention|
        ActionCable.server.broadcast "room_channel_user_#{mention.id}",
                                     mention: true
      end
    end

    respond_to do |format|
      format.html
      format.json { render json:  {message: 'all good'} }
    end
  end

  private

  def get_messages
    @messages = Message.for_display
    @message = current_user.messages.build if current_user
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def render_message(message)
    render(partial: 'message', locals: {message: message})
  end
end
