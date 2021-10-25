class UsersController < ApplicationController
  def my_portfolio
    @user = current_user
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end

  def unfollow
    friend_id = params[:friend_id]
    return unless friend_id

    friendship = Friendship.where(user_id: current_user.id, friend_id: friend_id).first
    friendship&.destroy
    redirect_to friends_path
  end

  def follow
    friend_id = params[:friend_id]
    return unless friend_id

    new_friend = User.find(friend_id)
    current_user.friends << new_friend if new_friend
    current_user.save
    redirect_to friends_path
  end

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end

  # def search
  #   query = params[:query]
  #   # debugger
  #   if params[:query].present? && !params[:query].empty?
  #     @friends = my_friends.where("first_name LIKE ? OR last_name LIKE ? OR email LIKE ?", "%#{query}%", "%#{query}%",
  #                                 "%#{query}%")
  #     respond_to do |format|
  #       format.js { render partial: "users/friends_result", locals: {friends: @friends} }
  #     end
  #   else
  #     respond_to do |format|
  #       format.js { render partial: "users/friends_result", locals: {friends: my_friends} }
  #     end
  #   end
  # end
  def search
    query = params[:friend]

    if params[:friend].present? && !params[:friend].empty?
      # @friend = User.where("first_name LIKE ? OR last_name LIKE ? OR email LIKE ?", "%#{query}%", "%#{query}%",
      #                      "%#{query}%").first
      @friends = User.search(query)
      if @friends
        @friends = current_user.except_self(@friends)
        respond_to do |format|
          format.js { render partial: "users/friends_result" }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "Couldnt find user"
          format.js { render partial: "users/friends_result" }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a friend name or email to search"
        format.js { render partial: "users/friends_result" }
      end

    end
  end
end
