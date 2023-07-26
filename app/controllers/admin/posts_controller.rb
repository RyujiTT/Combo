class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  def show
    unless Post.find_by(id: params[:id]) == nil
     @post = Post.find(params[:id])
     @group = @post.group.id
    else
      redirect_to admin_groups_path
    end
  end
  def destroy
    @admin_post = Post.find(params[:id])
    @group = @admin_post.group.id
    @admin_post.destroy
    redirect_to admin_group_path(@group)
  end
end
