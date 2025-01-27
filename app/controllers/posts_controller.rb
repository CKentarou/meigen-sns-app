class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def index
    @user = current_user
    sort_by = params[:sort_by] || session[:sort_by] || "random"
    session[:sort_by] = sort_by
    
    # セッションから投稿IDを取得
    post_ids = session[:posts]
    if sort_by == "favorites"
      # 「RELOAD Likes」ボタンが押された場合、favorites順に並び替え
      @posts = Post.left_joins(:favorites)
                   .group(:id)
                   .order("COUNT(favorites.id) DESC")
                   .limit(8)
    elsif sort_by == "random"
      # 「RELOAD Random」ボタンが押された場合、ランダムに並び替え
      @posts = Post.all.order("RANDOM()").limit(8)
    else
      # 通常のアクセス時、セッションからIDを使って投稿を取得
      if post_ids.present?
        @posts = Post.where(id: post_ids).limit(8)
      else
        @posts = Post.all.order("RANDOM()").limit(8)
      end
    end
  
    # 新たにIDをセッションに保存（ランダム表示か、favorites順表示かを問わず）
    session[:posts] = @posts.map(&:id)
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    if @post.user_id != current_user.id
      redirect_to posts_path(@post)
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.user_id == current_user.id
      if @post.update(post_params)
        redirect_to posts_path(@post)
      else
        render :edit
      end
    else
      redirect_to posts_path(@post)
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.user_id == current_user.id
      @post.destroy
    end
    redirect_to posts_path
  end

  def search
    uri = URI.parse("https://meigen.doodlenote.net/api/json.php")
    json = Net::HTTP.get(uri)
    result = JSON.parse(json)
    @post = Post.new(
      content: result.first["meigen"],
      author: result.first["auther"] 
    )
    render :new
  end

  private

  def post_params
    params.require(:post).permit(:content,:author)
  end
end
