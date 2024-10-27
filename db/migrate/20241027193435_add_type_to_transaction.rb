class AddTypeToTransaction < ActiveRecord::Migration[7.2]
  def change
    add_column :transactions, :type, :string
  end
end
