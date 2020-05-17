require 'rails_helper'

RSpec.describe Message, type: :model do
  context "check for read and correctness of senders and recievers" do
  	message = Message.create(outbox_id: 2, inbox_id: 1, body: "Luke I am your father")

  	it "should return false for Message.read" do
  		expect(message.read).to eq(false)
  	end

  	it "should return correct outbox" do
  		expect(message.outbox_id).to eq(2)
  	end

  	it "should return correct inbox" do
  		expect(message.inbox_id).to eq(1)
  	end
  end
end
