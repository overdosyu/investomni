class ChangeUserProfiles < ActiveRecord::Migration
  def change
    change_table :user_profiles do |t|
      t.remove :first_name
      t.remove :last_name
      t.column :name, :string
    end
  end
end
