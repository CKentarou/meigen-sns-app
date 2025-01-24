class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def index
    @user = current_user
    sort_by = params[:sort_by] || "random"

    @posts = 
      if sort_by == "favorites"
        Post.left_joins(:favorites)
            .group(:id)
            .order("COUNT(favorites.id) DESC")
            .limit(8)
      else
        Post.all.order("RANDOM()").limit(8)
      end
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
