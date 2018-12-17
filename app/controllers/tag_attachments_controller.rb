class TagAttachmentsController < ApplicationController
  before_action :require_login
  before_action :tag_attachment, only: [:show, :edit,:update, :destroy]

  def index
    @tag = Tag.find params[:tag_id]
    @product = @tag.product
    @categories = Category.where(tag_attachment_id: @tag.tag_attachment.try(:id))
    @tree = @categories.select(:id,:text,:ancestry,:mark).arrange_serializable.to_json
    @tree = @tree.gsub("children", "nodes").gsub(",\"mark\":2,\"nodes\":[]","").html_safe
  end

  def show
  end

  def new
    @tag_attachment = TagAttachment.new
    @tag = Tag.find params[:tag_id]
    @product = @tag.product
  end

  def create
    @tag = Tag.find params[:tag_id]
    @product = @tag.product
    
    @tag_attachment = TagAttachment.new(tag_attachment_params)
    @tag_attachment.name = params[:tag_attachment][:file].original_filename
    @tag_attachment.tag_id = params["tag_id"]

    respond_to do |format|
      if @tag_attachment.save
        tc = TagAttachment.find_by(name: @tag_attachment.name, tag_id: @tag_attachment.tag_id)
        notice = tc.present? ? "新增成功" : "请检查压缩包内文件格式是否正确"
        format.html { redirect_to tag_attachments_path(tag_id: @tag_attachment.tag_id), notice: notice }
        format.json { render :show, status: :created, location: @tag_attachment }
      else
        format.html { render :new }
        format.json { render json: @tag_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @tag = @tag_attachment.tag
    @product = @tag.product
  end

  def update
    _hash = tag_attachment_params.merge(tag_id: params["tag_id"])
    _hash = _hash.merge(name: params[:tag_attachment][:file].original_filename) if params[:tag_attachment][:file].present?

    if @tag_attachment.update(_hash)
      redirect_to tag_attachments_path(tag_id: @tag_attachment.tag_id), notice: '编辑成功'
    else
      render 'edit'
    end
  end

  def destroy
    @valid =  @tag_attachment.destroy
    # @tag_attachment.file.purge_later()
    if @valid
      redirect_to tag_attachments_path(tag_id: @tag_attachment.tag_id), notice: '删除成功'
    else
      @message = @tag_attachment.errors.full_messages.join(',')
      redirect_to tag_attachments_path(tag_id: @tag_attachment.tag_id), notice: '删除失败'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def tag_attachment
    @tag_attachment = TagAttachment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tag_attachment_params
    params.require(:tag_attachment).permit(:file, :remark, :attachment_path)
  end
end