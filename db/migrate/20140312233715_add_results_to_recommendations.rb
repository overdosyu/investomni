class AddResultsToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :result, :text
    add_column :recommendations, :is_finalize, :boolean, default: false
  end
end
