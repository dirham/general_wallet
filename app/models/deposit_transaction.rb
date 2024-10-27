class DepositTransaction < Transaction
  # A deposit requires a target wallet (where the money is deposited)
  validates :target_wallet, presence: true
end
