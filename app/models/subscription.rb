class Subscription < ApplicationRecord
  belongs_to :plan
  belongs_to :user

  enum :status, { unpaid: 0, paid: 1, cancelled: 2, expired: 3 }


  def self.get_subscription_from_session_id(session_id)
    Subscription.find_by(stripe_checkout_session_id: session_id)
  end
end
