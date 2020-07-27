class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # rubocop:disable Lint/ShadowingOuterLocalVariable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  def friend?(user)
    self.friends.include?(user)
  end

  def mutual_friends?(user)
    self.friend?(user) and user.friend?(self)
  end

  def confirm_friend(user)
    self.friends << user
  end

  def pending_friends
    self.friendships.map { |friendship| friendship.friend unless friendship.friend.friend?(self) }.compact
  end

  def friend_requests
    self.inverse_friendships.map { |friendship| friendship.user unless self.friend?(friendship.user) }.compact
  end

  # def friends
  #   friends_array = friendships.map { |friendship| friendship.friend if friendship.confirmed }
  #   friends_array += inverse_friendships.map { |friendship| friendship.user if friendship.confirmed }
  #   friends_array.compact
  # nd

  # def pending_friends
  #   friendships.map { |friendship| friendship.friend unless friendship.confirmed }.compact
  # end

  # def friend_requests
  #   inverse_friendships.map { |friendship| friendship.user unless friendship.confirmed }.compact
  # end

  # def confirm_friend(user)
  #   friendship = inverse_friendships.find { |friendship| friendship.user == user }
  #   friendship.confirmed = true
  #   friendship.save
  # end

  # def friend?(user)
  #   friends.include?(user)
  # end
end
# rubocop:enable Lint/ShadowingOuterLocalVariable
