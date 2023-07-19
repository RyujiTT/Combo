class Post < ApplicationRecord
  scope :group_posts, -> (group){ where(group_id: group.id) }
  
  belongs_to :group
  belongs_to :user
  
  validates :title, presence: true
end
