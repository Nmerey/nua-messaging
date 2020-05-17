 class MessagesController < ApplicationController
  
  def show
    @message = Message.find(params[:id])
    session[:outbox] = @message.outbox.id
    session[:inbox] = @message.inbox.id
    @message.read = true
    @message.save
  end

  def index
  	@messages = User.current.inbox.messages.reverse #Use reverse method for newest messages uptop
    @messages = @messages.paginate(page: params[:page],per_page: 10) #will_paginate gem used here
  end

  def new
    @message = Message.new
  end

  def prescription
    @current_user = User.current
    @default_admin = User.default_admin
    @lost_presc_message = "I have lost my prescription!/n" + @current_user.full_name
    @message = Message.create!(body: @lost_presc_message, outbox: @current_user.outbox, inbox: @default_admin.inbox )
    
    if PaymentProviderFactory.provider.debit_card(@current_user)
      @payment = Payment.create!(@current_user)
      flash[:success] = "Order is successfull"
      redirect_to 
    else
      render root
      flash[:alert] = "Transaction failed. Please try again"
    end
    
  end

  def create
    @outbox = Outbox.find(session[:outbox])
    @inbox = Inbox.find(session[:inbox])
    @message = Message.create!(body: params[:message][:body],outbox: @outbox, inbox: @inbox)

	if 1.week.ago < @message.created_at
    redirect_to '/'
    flash[:success] = "Message successfully sent"
	else
		@message.inbox = User.default_admin.inbox
		@message.save
    flash[:success] = "Message sent to admin"
	end

  end

end
