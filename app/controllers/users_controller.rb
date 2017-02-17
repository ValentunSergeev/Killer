class UsersController < ApplicationController
  before_action :authenticate_user!, :only_owner, only: [:games]
  before_action :set_user_by_uid

  def games
    @games = @user.games
    render 'games/index', assigns: { games: @games }
  end

  private

  def set_user_by_uid
    @user = User.find_by_uid(params[:uid])
    redirect_to root_path unless @user
  end

  def only_owner
    redirect_to root_path unless @user = current_user
  end
end
