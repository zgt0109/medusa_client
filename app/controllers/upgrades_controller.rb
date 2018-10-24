class UpgradesController < ApplicationController
  before_action :set_product, only: [:check, :download]

  def check
    return render_json(code: "01", message: "客户端软件不存在", status: 200) if @product.blank?
    tag = Tag.find_by(product_id: @product.id,name: upgrade_params[:version])
    return render_json(code: "02", message: "版本不存在", status: 200) if tag.blank?
    tags = @product.tags.where(is_public: true).where.not(name: upgrade_params[:version]).where("id > ?", tag.id).limit(1)
    remote_ips = tags.first.try(:remote_ip)
    if tags.present?
      if remote_ips.present?
        Rails.logger.debug("请求的IP地址是：#{request.remote_ip}")
        if remote_ips.split(',').include?(request.remote_ip)
          render json: {code: "00", message: "客户端需要更新", content: tags.first.try(:content)}, status: 200
        else
          render_json(code: "03", message: "客户端ip不在白名单内", status: 200)
        end
      else
        render json: {code: "00", message: "客户端需要更新", content: tags.first.try(:content)}, status: 200
      end
    else
      render_json(code: "04", message: "客户端已是最新版", status: 200)
    end

  end

  def download
    if @product.blank?
      return render_json(code: "01", message: "客户端软件不存在", status: 200)
    else
      @tag = Tag.find_by(product_id: @product.id,name: upgrade_params[:version])
      return render_json(code: "02", message: "版本不存在", status: 200) if @tag.blank?
      @tags = @product.tags.where(is_public: true).where.not(name: upgrade_params[:version]).where("id > ?", @tag.id).limit(1)
      if @tags.blank?
        return render_json(code: "04", message: "客户端已是最新版", status: 200)
      else
        tag_hash = {code: "", version: "", tag_attachment: ""}
        @tags.each do |tag|
          _tag_attachment = []
          tag_attachments = tag.tag_attachments
          tag_attachments.each do |tag_attachment|
            tag_attachment_hash = {
              name: tag_attachment.name,
              url: "#{ENV['QINIU_DOMAIN']}/#{tag_attachment.file.key}",
              attachment_path: tag_attachment.attachment_path,
              created_at: tag_attachment.created_at.strftime('%Y-%m-%d %H:%M')
            }
          _tag_attachment << tag_attachment_hash
          end

          tag_hash = {
            name: tag.product.name,
            version: tag.name, 
            tag_attachment: _tag_attachment
          }
        end
        render json: {code: "00", message: "成功获取附件列表", result: tag_hash}, status: 200

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