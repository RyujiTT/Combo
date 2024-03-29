class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new(post_params)
  end

  def show
    @post = Post.find(params[:id])
    @group = @post.group.id
    @post_comment = PostComment.new
  end

  def index
    @posts = Post.all
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    @group = @post.group
    @posts = Post.group_posts(@group).page(params[:page]).per(8)
    if @post.save
      flash[:notice] = "投稿に成功しました。"
      redirect_to @group
    else
      flash.now[:alert] = "投稿に失敗しました。"
      render 'public/groups/show'
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "You have updated post successfully."
    else
      render "edit"
    end
  end

  def destroy
    @group = @post.group.id
    @post.destroy
    redirect_to group_path(@group)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :group_id)
  end

  def ensure_correct_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to posts_path
    end
  end
end
