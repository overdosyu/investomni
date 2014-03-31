class Trade < ActiveRecord::Base
  belongs_to :user

  validates_inclusion_of :action, :in => [:buy, :sell]

  def action
    read_attribute(:action).to_sym if read_attribute(:action)
  end

  def action= (value)
    write_attribute(:action, value.to_s)
  end

  def symbol= (value)
    write_attribute(:symbol, value.to_s.upcase)
  end
end
