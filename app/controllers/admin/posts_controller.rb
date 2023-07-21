class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  def show
     @post = Post.find(params[:id])
     @group = @post.group.id
  end
  def destroy
    @post = Post.find(params[:id])
    @group = @post.group.id
    @post.destroy
    redirect_to admin_group_path(@group)
  end
end
