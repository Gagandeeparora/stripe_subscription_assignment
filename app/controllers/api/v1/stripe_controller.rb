class Api::V1::StripeController < ApplicationController

	# We can move processing background also for better latency.
	def stripe_events

		payload = request.body.read

		# add your cli key here for testing of webhook
		webhook_secret = 'whsec_35'
	 
    # Retrieve the event by verifying the signature using the raw body and secret if webhook signing is configured.
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    event_data = StripeApi.signature_match(payload,sig_header,webhook_secret)
    if event_data[:status] == 'Error'
   	  return render json: {status: 'Error'}, status: 400
   	end
    event = event_data[:event_data]
	  data = event['data']
	  data_object = data['object']
	  event_type = event.type
	  Rails.logger.info "Stripe Event Type :: #{event.type}"

	  case event_type
	  
	  #handle once checkout session is completed
	  when 'checkout.session.completed'
	  	session_id = data_object.id
	  	subscription = Subscription.get_subscription_from_session_id(session_id)
	  	if subscription && (data_object.status == 'complete') && (data_object.payment_status == 'paid')
	  		subscription.update(status: 1, stripe_subscription_id:  data_object.subscription)
	  	end

	  # handle when subscription is expired
	  when 'checkout.session.expired'
	  	session_id = data_object.id
	  	subscription = Subscription.get_subscription_from_session_id(session_id)
	  	if subscription && data_object.status == 'expired'
	  		subscription.update(status: 3, stripe_subscription_id:  data_object.subscription)
	  	end

	  # handle when subscription is cancelled
	  when 'customer.subscription.deleted'
	  	if data_object.status == 'canceled'
	  		subscription = Subscription.find_by(stripe_subscription_id: data_object.id)
	  		subscription.update(status: 2) if (subscription && subscription.paid? )
	  	end
	  end

  	render json: {status: 'success'}
	end
end

