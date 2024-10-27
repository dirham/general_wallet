class TransferTransaction < Transaction
  # A transfer requires both source and target wallets
  validates :source_wallet, presence: true
  validates :target_wallet, presence: true
end
