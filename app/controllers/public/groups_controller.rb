class Public::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy, :permits]

  def new
    @group = Group.new
  end

  def index
    @post = Post.new
    @groups = Group.all.page(params[:page]).per(6)
    @user = User.find(current_user.id)
  end

  def show
    @group = Group.find(params[:id])
    @post = @group.posts.build
    @posts = Post.group_posts(@group).page(params[:page]).per(8)
    #投稿表示順変更機能
    if params[:latest]
      @posts = Post.group_posts(@group).latest.page(params[:page]).per(8)
    elsif params
      @posts = Post.group_posts(@group).favorite_count.page(params[:page]).per(8)
    else
      @posts = Post.group_posts(@group).page(params[:page]).per(8)
    end
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      redirect_to groups_path, method: :post
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render 'edit'
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path
  end

  def permits
    @group = Group.find(params[:id])
    @permits = @group.permits.page(params[:page])
  end

  def members
    @group = Group.find(params[:id])
    @group_users = @group.users.page(params[:page]).per(12)
  end


  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  # params[:id]を持つ@groupのowner_idカラムのデータと自分のユーザーIDが一緒かどうかを確かめる。
  # 違う場合はグループ詳細ページを再表示させる。（オーナー以外は編集、削除、加入希望者ページの遷移はできない）before_actionで使用する。
  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to group_path(@group), alert: "グループオーナーのみ編集が可能です"
    end
  end

  # def check_group_user
  #   @group = current_user.my_groups.find_by(id: params[:id])
  #   unless @group
  #     redirect_to root_url
  #   end
  # end
end
