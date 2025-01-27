class FavoritesController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: post.id)
    favorite.save
    redirect_to posts_path(sort_by: "session")
  end

  def destroy
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: post.id)
    favorite.destroy
    #リダイレクトではなくページをリロードする使用に今後する
    redirect_to posts_path(sort_by: "session")
  end
end
