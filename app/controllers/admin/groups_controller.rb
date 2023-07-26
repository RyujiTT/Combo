class Admin::GroupsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @groups = Group.all.page(params[:page]).per(8)
  end

  def show
    @group = Group.find(params[:id])
    @posts = Post.group_posts(@group).page(params[:page]).per(8)
    if params[:latest]
      @posts = Post.group_posts(@group).latest.page(params[:page]).per(8)
    elsif params[:favorite_count]
      @posts = Post.group_posts(@group).favorite_count.page(params[:page]).per(8)
    else
      @posts = Post.group_posts(@group).page(params[:page]).per(8)
    end
    @posts_count = Post.group_by_day(:created_at).count
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to admin_groups_path
  end

  def members
    @group = Group.find(params[:id])
     @group_users = @group.users.page(params[:page]).per(12)
  end
end
