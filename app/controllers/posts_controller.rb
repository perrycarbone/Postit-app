class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote, :destroy]
  before_action :require_user, except: [:show, :index]
  before_action :require_creator, only: [:edit, :update]

  def index
    @posts = Post.limit(Post::PER_PAGE).offset(params[:offset])
    @pages = (Post.all.size.to_f / Post::PER_PAGE).ceil
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      flash['notice'] = "Your post was created."
      redirect_to post_path(@post)
    else #validation error
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash['notice'] = 'The post was updated.'
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.create(voteable: @post, creator: current_user, vote: params[:vote])

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash['notice'] = "Your vote was counted."
        else
          flash['error'] = "You can only vote on a post once."
        end
        redirect_to :back
      end
      format.js
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids:[])
  end

  def set_post
    @post = Post.find_by(slug: params[:id])
  end

  def require_creator
    access_denied unless logged_in? and (current_user == @post.creator || current_user.admin?)
  end
end

