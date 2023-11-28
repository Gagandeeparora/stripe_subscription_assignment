class SubscriptionsController < ApplicationController
	
	include CommonUtility

	def index
		@plans = Plan.all.map{|p| ["#{p.name} - #{p.amount} #{p.currency}", p.name ] }
	end

	def create
	  user = User.find_or_create_by(email: subcripton_params[:email])
	  plan = Plan.find_by(name: subcripton_params[:plan_id])
	  if plan
	  	price_plans = StripeApi.plan_list(plan.name)
	  	options_hash = initialize_hash
	  	options_hash = {success_url: success_subscriptions_url, failure_url: failure_subscriptions_url,plan_id: price_plans[:response].data[0].id, customer_id: user.stripe_customer_id}
	  	session_response = StripeApi.create_session(options_hash)
      if session_response[:success]
  			subscription_hash = initialize_hash
  			subscription_hash = {plan_id: plan.id, stripe_checkout_session_id: session_response[:response].id}
      	@subscription =  user.subscriptions.new(subscription_hash)
  			if @subscription.save
		 			redirect_to session_response[:response].url, allow_other_host: true
				else
					render :index
				end
		 	else
		 		flash[:error] = session_response[:error]
		 		redirect_to subscriptions_url
		 	end
	  else
			flash[:error] = 'No Plan exist for selection'
			redirect_to subscriptions_url
	  end

	end

	def success
		if params[:session_id]
			subscription = Subscription.get_subscription_from_session_id(params[:session_id])
			if !subscription.paid?
				session_data = StripeApi.session_retrieve params[:session_id]
				if session_data && (session_data.status == 'complete') && (session_data.payment_status == 'paid')
		  		subscription.update(status: 1, stripe_subscription_id:  session_data.subscription)
		  	else
		  		flash[:error] = 'We are verifying your payment. Allow us sometime.'
		  	end
			end
		else
			flash[:error] = 'Session id missing'
		end
	end

	def failure
	end

	private
	def subcripton_params
		params.require(:subscription).permit(:plan_id,:email)
	end
end

