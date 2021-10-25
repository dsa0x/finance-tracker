class FriendshipsController < ApplicationController
  def destroy
    friend_id = params[:id]
    return unless friend_id

    friendship = Friendship.where(user_id: current_user.id, friend_id: friend_id).first
    friendship&.destroy
    flash[:notice] = "Stopped following"
    redirect_to friends_path
  end

  def create
    friend_id = params[:id]
    return unless friend_id

    new_friend = User.find(friend_id)
    current_user.friends << new_friend if new_friend
    if current_user.save
      flash[:notice] = "Started following #{new_friend.full_name}"
    else
      flash[:alert] = "Something went wrong"
    end
    redirect_to friends_path
  end
end
