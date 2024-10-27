class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: "Wallet", optional: true
  belongs_to :target_wallet, class_name: "Wallet", optional: true

  validates :amount, numericality: { greater_than: 0 }
  validate :at_least_one_wallet
  validate :minimum_deposit_amount, if: :is_deposit?

  def at_least_one_wallet
    if source_wallet.nil? and target_wallet.nil?
      errors.add :wallet, "Either target wallet or source wallet shold present"
    end
  end

  def minimum_deposit_amount
    errors.add(:amount, "Minimum for deposit is $5") if amount < 5
  end

  def is_deposit?
    target_wallet.present? && source_wallet.nil?
  end
end
