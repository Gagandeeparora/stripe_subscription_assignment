class StripeApi
	class << self
		def create_session(options_hash ={})
			begin
				session = Stripe::Checkout::Session.create({
										customer: options_hash[:customer_id],
							      mode: 'subscription',
							      line_items: [{
							        quantity: 1,
							        price: options_hash[:plan_id]
							      }],
							      success_url: options_hash[:success_url] + '?session_id={CHECKOUT_SESSION_ID}',
							      cancel_url: options_hash[:failure_url] + '?session_id={CHECKOUT_SESSION_ID}',
							    })
				{success: true, response: session}
			rescue StandardError => e
				Rails.logger.error "Stripe Session Error :: #{e}" 
				{success: false, error: e.message}
			end
		end

		def plan_list(plan_name)
			begin
				prices = Stripe::Price.list(
								   lookup_keys: [plan_name],
								   expand: ['data.product']
								 )
				{success: true, response: prices}
			rescue StandardError => e
				Rails.logger.error "Stripe Plans List Error :: #{e}" 
				{success: false, error: e.message}
			end
		end

		def create_customer(email)
			Stripe::Customer.create({ email: email })
		end

		def signature_match(payload,sig_header,webhook_secret)
			begin
	      event = Stripe::Webhook.construct_event(
	        payload, sig_header, webhook_secret
	      )
	    rescue JSON::ParserError => e
	    	Rails.logger.debug 'Webhook signature parsing error.'
	      return {status: 'Error'}
	    rescue Stripe::SignatureVerificationError => e
	      Rails.logger.debug 'Webhook signature verification failed.'
	      return  {status: 'Error'}
	    rescue Exception => e
	    	Rails.logger.debug 'Webhook signature exception occured.'
	    	return  {status: 'Error'}
	    end
	    return {status: 'Success', event_data: event}
		end

		def session_retrieve(session_id)
			Stripe::Checkout::Session.retrieve session_id
		end
	end
end