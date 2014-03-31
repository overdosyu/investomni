class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.string :symbol
      t.string :action
      t.text :note
      t.float :price
      t.references :user, index: true

      t.timestamps
    end
  end
end
