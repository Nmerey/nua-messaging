require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
	let(:current_user) {User.create!}
	let(:doctor) {User.create!(is_doctor: true, is_patient: false)}
	let(:admin) { User.create!(is_admin: true, is_patient: false)}
	let(:new_outbox) {Outbox.create!(user_id: current_user.id)}
	let(:new_inbox) {Inbox.create!(user_id: doctor.id)}
	let(:admin_inbox) {Inbox.create!(user_id: admin.id)}
	let(:new_message) { Message.create!(body: "test", outbox_id: new_outbox.id, inbox_id: new_inbox.id)}

	describe "GET show" do
		it "should make message read" do
			expect{
				get :show, params: {id: new_message.id}
				new_message.reload
			}.to change(new_message,:read)
		end
	end

	describe "POST create" do

		it "should make unread message increment" do
			expect{

				get :show, params: {id: new_message.id} #In our app you can only reply, so original message should be visited first
				post :create, params: {message: {body: "test"}}

			}.to change(Message.where(read:false),:count).by(1)
		end
	end

	describe "POST prescription" do

		it "should send a message to admin" do
			expect{
				post :prescription
			}.to change(Message.all, :count).by(1)
		end
	end

end
