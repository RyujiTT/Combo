class Public::UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @current_user = current_user
    @user = User.find(params[:id])
  end


  def edit
    @current_user = current_user
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @current_user = current_user
    if @current_user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user_info successfully."
    else
      render "edit"
    end
  end

  def unsubscribe
  end

  def withdrawal
     @user = current_user
     # is_active(会員ステータス)をfalse(退会)に更新する
     @user.update(is_deleted: true)
     reset_session
     flash[:notice] = "退会処理を実行いたしました"
     redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :is_deleted)
  end
end
