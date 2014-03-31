class Recommendation < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  default_scope order('created_at DESC')

  # change to enum after update Rails to 4.1
  validates_inclusion_of :action, :in => [:buy, :hold, :sell]
  validates_inclusion_of :term, :in => [:week, :month, :quarter]

  validates_presence_of :symbol, :note, :price

  attr_accessor :stock_quote
  serialize :result, Hash

  def action
    read_attribute(:action).to_sym if read_attribute(:action)
  end

  def action= (value)
    write_attribute(:action, value.to_s)
  end

  def term
    read_attribute(:term).to_sym if read_attribute(:term)
  end

  def term= (value)
    write_attribute(:term, value.to_s)
  end

  def symbol= (value)
  	write_attribute(:symbol, value.to_s.upcase)
  end

  def end_at
    if term == :week
      created_at + 1.weeks
    elsif term == :month
      created_at + 1.months
    elsif term == :quarter
      created_at + 3.months
    end
  end

end
