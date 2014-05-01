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

  def page_title(subtitle = nil)
    if subtitle.present?
      content_for :title, subtitle
    else
      content_for?(:title) ? content_for(:title) + ' - investomni' : 'investomni'
    end
  end

  def meta_keywords(tags = nil)  # for SEO
    if tags.present?
      content_for :meta_keywords, tags
    else
      content_for?(:meta_keywords) ? [content_for(:meta_keywords), APP_CONFIG['default_meta_keywords']].join(', ') : APP_CONFIG['default_meta_keywords']
    end
  end

  def meta_description(desc = nil)  # for SEO
    if desc.present?
      content_for :meta_description, desc
    else
      content_for?(:meta_description) ? content_for(:meta_description) : APP_CONFIG['default_meta_description']
    end
  end

end
