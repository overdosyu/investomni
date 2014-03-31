json.array!(@recommendations) do |recommendation|
  json.extract! recommendation, :id, :symbol, :action, :note, :price
  json.url recommendation_url(recommendation, format: :json)
end
