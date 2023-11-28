module CommonUtility
  extend ActiveSupport::Concern

  def initialize_hash
    HashWithIndifferentAccess.new
  end
end