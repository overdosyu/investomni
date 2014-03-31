class ChangeTrades < ActiveRecord::Migration
  def change
    change_table :trades do |t|
      t.remove :admin_user
      t.references :user, index: true
    end
  end
end
