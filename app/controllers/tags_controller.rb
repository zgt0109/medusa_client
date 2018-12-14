class TagsController < ApplicationController
  before_action :require_login
  before_action :set_tag, only: [:show, :edit,:update, :destroy]

  def index
    @product = Product.find_by(id: params[:product_id])
    @tags = @product.tags.page(params[:page] || 1).per_page(params[:per_page] || 10).order("id desc")
  end

  def show
  end

  def new
    @tag = Tag.new
    @product = Product.find(params[:product_id])
  end

  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      redirect_to tags_path(product_id: @tag.product_id), notice: '新增成功'
    else
      render :new
    end
  end

  def edit
    @product = @tag.product
  end

  def update
    if @tag.update(tag_params)
      redirect_to tags_path(product_id: @tag.product_id), notice: '编辑成功'
    else
      render :edit
    end
  end

  def destroy
    @valid =  @tag.destroy

    if @valid
      redirect_to tags_path(product_id: @tag.product_id), notice: '删除成功'
    else
      @message = @tag.errors.full_messages.join(',')
      redirect_to tags_path(product_id: @tag.product_id), notice: '删除失败'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = Tag.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tag_params
    params.require(:tag).permit(:product_id, :name, :starter_ver, :content, :is_public, :remote_ip, :force_update, :bootstrap)
  end
end