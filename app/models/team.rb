class Team < ApplicationRecord
  has_one :wallet, as: :owner
end
