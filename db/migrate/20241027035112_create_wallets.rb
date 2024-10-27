class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets do |t|
      t.references :owner, polymorphic: true, index: true
      t.timestamps
    end
  end
end
