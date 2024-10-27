class Wallet < ApplicationRecord
  # related transactions where the wallet are the receiver
  has_many :outgoing_transactions, class_name: "Transaction", foreign_key: :source_wallet_id
  # related data where current wallet are the sender
  has_many :incoming_transactions, class_name: "Transaction", foreign_key: :target_wallet_id

  def balance
    incoming_transactions.sum(:amount) - outgoing_transactions.sum(:amount)
  end

  def transfer(target_wallet, amount)
    raise "Insufficient funds" if balance < amount

    ActiveRecord::Base.transaction do
      Transaction.create!(source_wallet: self, target_wallet: target_wallet, amount: amount)
    end
  end

  # assuming all type of wallet (user, team and stock sharing deposit logic)
  def deposit(amount)
    ActiveRecord::Base.transaction do
      # set source wallet as nil since it was not clear where and how (user, team and stock could be deposit) it could
      # form direct bank account or others thrid-party wallet service
      Transaction.create!(source_wallet: nil, target_wallet: self, amount: amount)
    end
  end
end
