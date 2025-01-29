class FavoritesController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: post.id)
    favorite.save
    redirect_to URI.parse(request.referer).tap { |uri|
      query_params = Rack::Utils.parse_query(uri.query).merge("sort_by" => "session")
      uri.query = query_params.to_query
    }.to_s
  end

  def destroy
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: post.id)
    favorite.destroy
    #リダイレクトではなくページをリロードする使用に今後する
    redirect_to URI.parse(request.referer).tap { |uri|
      query_params = Rack::Utils.parse_query(uri.query).merge("sort_by" => "session")
      uri.query = query_params.to_query
    }.to_s
  end
end
