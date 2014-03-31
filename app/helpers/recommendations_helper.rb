module RecommendationsHelper
  def title(recommendation)
    [recommendation.action, recommendation.symbol, 'at', number_to_currency(recommendation.price), 'for', recommendation.term].join(' ')
  end

  def result_str(recommendation)
    if recommendation.is_finalize
      result = recommendation.result
      if result[:action] == recommendation.action  # SUCCESS
      	if result[:action] == :buy
          "<span class='glyphicon glyphicon-ok success'></span> price up #{result[:price].abs_diff_percent_of(recommendation.price)}% after #{days_between(recommendation.created_at, Date.parse(result[:date]))} days."
        elsif result[:action] == :sell
          "<span class='glyphicon glyphicon-ok success'></span> price down #{result[:price].abs_diff_percent_of(recommendation.price)}% after #{days_between(recommendation.created_at, Date.parse(result[:date]))} days."
        else
          "<span class='glyphicon glyphicon-ok success'></span> price holded."
        end
      else  # FAIL
      	if result[:action] == :buy
          "<span class='glyphicon glyphicon-remove fail'></span> price up #{result[:price].abs_diff_percent_of(recommendation.price)}% after #{days_between(recommendation.created_at, Date.parse(result[:date]))} days."
        elsif result[:action] == :sell
          "<span class='glyphicon glyphicon-remove fail'></span> price down #{result[:price]} #{result[:price].abs_diff_percent_of(recommendation.price)}% after #{days_between(recommendation.created_at, Date.parse(result[:date]))} days."
        else
          "<span class='glyphicon glyphicon-remove fail'></span> price holded."
        end
      end
    else
      "#{days_between(Time.now, recommendation.end_at)} days left, so far so good..."
    end
  end

  private
  def days_between(from_datetime, thru_datetime)
    (thru_datetime.to_date - from_datetime.to_date).to_i
  end
end

class Numeric
  def abs_diff_percent_of(n)
    ((1.0 - (self.to_f / n.to_f)).abs * 100.0).round(2)
  end
end


