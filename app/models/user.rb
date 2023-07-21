class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  scope :delete_users, -> { where(is_deleted: true) }
  scope :active_users, -> { where.not(is_deleted: true) }

  has_many :groups, class_name: "Group", foreign_key: :owner_id
  has_many :group_users, dependent: :destroy
  has_many :my_groups, through: :group_users, source: :group
  has_many :permits, dependent: :destroy
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true

  has_many :posts
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # 退会してなければfalseを返す
  def active_for_authetication?
    super && (is_deleted == false)
  end
end
