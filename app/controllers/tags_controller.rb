class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit,:update, :destroy]

  def index
    @product = Product.find_by(id: params[:product_id])
    @tags = @product.tags
  end

  def show
  end

  def new
    @tag = Tag.new
    @product = Product.find(params[:product_id])
  end

  def create
    @tag = Tag.new(tag_params)
    @tag.is_public = params[:is_public]
    @tag.product_id = params[:product_id]

    if @tag.save
      redirect_to tags_path(product_id: @tag.product_id), notice: '新增成功'
    else
      render 'new'
    end
  end

  def edit
    @product = @tag.product
  end

  def update
    _hash = tag_params.merge(is_public: params[:is_public])
    if @tag.update(_hash)
      redirect_to tags_path(product_id: @tag.product_id), notice: '编辑成功'
    else
      render 'edit'
    end
  end

  def destroy
    @valid =  @tag.destroy

    if @valid
      @message = "删除成功"
      redirect_to tags_path(product_id: @tag.product_id), notice: '删除成功'
    else
      @message = @tag.errors.full_messages.join(',')
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = Tag.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tag_params
    params.require(:tag).permit(:product_id, :name, :is_public, :remote_ip)
  end
end