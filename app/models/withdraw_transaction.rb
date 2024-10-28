class WithdrawTransaction < Transaction
  # A withdrawal requires a source wallet (where the money is withdrawn from)
  validates :source_wallet, presence: true
end
