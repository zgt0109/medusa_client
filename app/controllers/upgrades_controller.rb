class UpgradesController < ApplicationController
  before_action :set_product, only: [:check, :download]

  def check
    return render_json(code: -1, message: "客户端软件不存在", status: 200) if @product.blank?
    tag = Tag.find_by_name(upgrade_params[:version])
    return render_json(code: -1, message: "版本不存在", status: 200) if tag.blank?
    tags = @product.tags.where(is_public: true).where.not(name: upgrade_params[:version]).where("id > ?", tag.id).limit(1)
    remote_ips = tags.first.try(:remote_ip)
    if tags.present?
      if remote_ips.present?
        if remote_ips.split(',').include?(request.remote_ip)
          Rails.logger.debug("请求的IP地址是：#{request.remote_ip}")
          render_json(code: 0, message: "客户端需要更新", status: 200)
        else
          render_json(code: -1, message: "客户端ip不在白名单内", status: 200)
        end
      else
        render_json(code: 0, message: "客户端需要更新", status: 200)
      end
    else
      render_json(code: -1, message: "客户端已是最新版", status: 200)
    end

  end

  def download
    if @product.blank?
      return render_json(code: -1, message: "客户端软件不存在", status: 200)
    else
      @tag = Tag.find_by_name(upgrade_params[:version])
      return render_json(code: -1, message: "版本不存在", status: 200) if @tag.blank?
      @tags = @product.tags.where(is_public: true).where.not(name: upgrade_params[:version]).where("id > ?", @tag.id).limit(1)
      if @tags.blank?
        render json: []
      else
        _result = []
        @tags.each do |tag|
          _tag_attachment = []
          tag_attachments = tag.tag_attachments
          tag_attachments.each do |tag_attachment|
            tag_attachment_hash = {
              name: tag_attachment.name,
              url: "#{ENV['QINIU_DOMAIN']}/#{tag_attachment.file.key}",
              attachment_path: tag_attachment.attachment_path
            }
          _tag_attachment << tag_attachment_hash
          end

          tag_hash = {
            name: tag.product.name,
            version: tag.name, 
            tag_attachment: _tag_attachment
          }
          _result << tag_hash
        end
        render json: _result
      end
      
    end
  end

  private
    def set_product
      @product = Product.find_by(name: params[:name])
    end

    def upgrade_params
      params.permit(:name, :version)
    end
end