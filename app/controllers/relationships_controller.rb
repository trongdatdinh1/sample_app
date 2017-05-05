class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def index
    @title = params[:title]
    @user = User.find_by id: params[:user_id]
    unless @user
      flash[:error] = t "something_went_wrong"
      redirect_to root_path
    end
      @users = @user.send(@title).paginate page: params[:page]
      render "shared/show_follow"
  end

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow @user
      respond_to do |format|
        format.html{redirect_to user_path}
        format.js
      end
    else
      flash[:error] = t "something_went_wrong"
      redirect_to root_path
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to user_path}
      format.js
    end
    @follow = current_user.active_relationships.build
  end
end
