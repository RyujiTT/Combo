class Post < ApplicationRecord
  extend OrderAsSpecified
  scope :group_posts, -> (group){ where(group_id: group.id) }

  belongs_to :group
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user


  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  validates :title, presence: true
  validates :title, presence: true

  scope :latest, -> {order(created_at: :desc)}

  def self.favorite_count
    ids = includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}.pluck(:id)
    where(id: ids).order_as_specified(id: ids)
  end

  def self.looks(word)
    self.where("title LIKE?", "%#{word}%")
  end

  scope :created_days_ago, -> (n) { where(created_at: n.days.ago.all_day) }

  def self.past_week_count
   (0..6).map { |n| created_days_ago(n).count }.reverse
  end
end
