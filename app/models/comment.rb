class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :recommendation

  validates :content, presence: true
end
