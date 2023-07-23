class Post < ApplicationRecord
  scope :group_posts, -> (group){ where(group_id: group.id) }

  belongs_to :group
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy


  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  validates :title, presence: true
  validates :title, presence: true

  scope :latest, -> {order(created_at: :desc)}
  #scope :favorite_count, -> {order(favorites: :desc)}

  def self.favorite_count
    includes(:favorites).sort_by {|x| x.post_comments.includes(:favorites).size }.reverse
  end
end
