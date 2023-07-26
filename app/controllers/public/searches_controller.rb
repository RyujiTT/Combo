class Public::SearchesController < ApplicationController
  before_action :authenticate_user!
  def search
    @word = params[:word]
    @group = Group.find(params[:id])
    @posts = Post.group_posts(@group).looks(params[:word])
  end
end
