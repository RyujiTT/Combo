class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  # 会員一覧
  def index
    @users = User.page(params[:page]).per(10)

    if params[:delete_users]
      @users = User.delete_users
    elsif params[:active_users]
      @users = User.active_users
    else
      @users = User.page(params[:page]).per(10)
    end
  end

  # 会員詳細画面
  def show
    @user = User.find(params[:id])
  end

  # 会員編集画面
  def edit
    @user = User.find(params[:id])
  end

  # 会員情報更新
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path,notice: "会員情報を更新しました。"
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :is_deleted)
  end

end
