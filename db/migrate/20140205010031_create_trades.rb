class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.string  :action
      t.string  :symbol
      t.integer :shares
      t.float   :price
      t.references :admin_user, index: true

      t.timestamps
    end
    add_index :trades, [:symbol]
  end
end
