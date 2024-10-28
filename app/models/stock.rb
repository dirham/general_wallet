class Stock < ApplicationRecord
  has_one :wallet, as: :owner
end
