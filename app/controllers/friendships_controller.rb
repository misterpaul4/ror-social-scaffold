class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    friendship = current_user.friendships.build(friend_id: params[:friend_id])
    if friendship.save
      redirect_to users_path, notice: 'friend request sent.'
    else
      redirect_to posts_path, alert: 'You cannot send this user a friend request.'
    end
  end

  def accept
    friend = User.find(params[:friend_id])
    current_user.confirm_friend(friend)
    friend.request_accepted(current_user)
    redirect_to users_path, notice: 'friend request accepted.'
  end

  def reject
    friendship = current_user.inverse_friendships.where(user_id: params[:friend_id])[0]
    friendship.destroy
    redirect_to users_path, notice: 'friend request rejected.'
  end

  private

  def friendship_params
    params.require(:friendship).permit(:friend_id)
  end
end
