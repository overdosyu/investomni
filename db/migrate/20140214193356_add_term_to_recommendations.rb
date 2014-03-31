class AddTermToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :term, :string
  end
end
