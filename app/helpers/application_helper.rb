module ApplicationHelper
  def pretty_date(datetime)
    if datetime > 1.days.ago
      time_ago_in_words(datetime) + ' ago'
    else
      datetime.to_date.to_formatted_s(:long)
    end
  end

  def bootstrap_type(type)
    case type
      when :alert then "alert-warning"
      when :error then "alert-danger"
      when :notice then "alert-info"
      when :success then "alert-success"
    end
  end

end
