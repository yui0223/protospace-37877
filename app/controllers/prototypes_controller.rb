class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :move_to_index, only: [:destroy, :edit]

  def index
    @prototypes = Prototype.includes(:user).order("created_at DESC")
  end

  def new
      @prototype = Prototype.new
  end

  def create
      @prototypes = Prototype.new(prototype_params)
    if 
      @prototypes.save
      redirect_to root_path(@prototype)
    else
      render :new
    end
  end

  def destroy
      @prototype = Prototype.find(params[:id])
      @prototype.destroy
      redirect_to root_path(@prototype)
  end

  def edit
      @prototype = Prototype.find(params[:id])
  end

  def update
      @prototype = Prototype.find(params[:id])
    if
      @prototype.update(prototype_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def show
      @prototype = Prototype.find(params[:id])
      @comment = Comment.new
      @comments = @prototype.comments
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def move_to_index
    @prototype = Prototype.find(params[:id])
    unless user_signed_in? && current_user.id == @prototype.user.user_id
      redirect_to action: :index
    end
  end
end