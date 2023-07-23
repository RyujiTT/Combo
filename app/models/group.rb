class Group < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users, source: :user
  has_many :permits, dependent: :destroy
  has_many :posts

  validates :name, presence: true
  validates :introduction, presence: true
  has_one_attached :group_image

  def is_owned_by?(user)
    owner.id == user.id
  end
  def includesUser?(user)
    group_users.exists?(user_id: user.id)
  end

  after_commit do
    GroupUser.find_or_create_by(user_id: owner_id, group_id: id)
  end
end
