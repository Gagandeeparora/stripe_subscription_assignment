class User < ApplicationRecord

	validates :email, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }

	has_many :subscriptions


	def stripe_customer_id
		if stripe_id.nil?
			customer = StripeApi.create_customer(email)
			update(stripe_id: customer.id)
		end
		stripe_id
	end
end