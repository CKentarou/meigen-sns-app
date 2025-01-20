class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
    @user = User.find(params[:id])
    if @user.id != current_user.id
      redirect_to user_path(@user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.id == current_user.id
      if @user.update(user_params)
        redirect_to user_path(@user)
      else
        render :edit
      end
    else
      redirect_to user_path(@user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image)
  end
end
