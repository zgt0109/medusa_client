class UpgradesController < ApplicationController
  before_action :set_product, only: [:check, :download]

  def check
    return render_json(code: "01", message: "客户端软件不存在", status: 200) if @product.blank?
    tag = Tag.find_by(product_id: @product.id,name: upgrade_params[:version])
    return render_json(code: "02", message: "版本不存在", status: 200) if tag.blank?
    tags = @product.tags.where(is_public: true).where.not(name: upgrade_params[:version]).where("id > ?", tag.id)

    if tags.present?
      Rails.logger.debug("请求的IP地址是：#{request.remote_ip}")
      tag_hash = {file_count: "", kb_size: "", content: ""}
      _tags = []
      tags.each do |tag|
        remote_ips = tag.try(:remote_ip)
        if remote_ips.present?
          if remote_ips.split(',').include?(request.remote_ip)
            _hash = {
              ver: "Ver_#{tag.name}",
              file_count: tag.tag_attachment.blank? ? 0 : tag.tag_attachment.categories.where(mark: 2).size,
              kb_size: tag.tag_attachment.blank? ? 0 : tag.tag_attachment.file.byte_size/1024,
              bootstrap: tag.try(:bootstrap),
              force_update: tag.try(:force_update),
              content: tag.try(:content)
            }
            _tags << _hash
            # render json: {code: "00", message: "客户端需要更新", content: tag.try(:content)}, status: 200
          else
            # render json: {code: "03", message: "客户端ip不在白名单内"}, status: 200 and return
            next
          end
        else
          _hash = {
            ver: "Ver_#{tag.name}",
            file_count: tag.tag_attachment.blank? ? 0 : tag.tag_attachment.categories.where(mark: 2).size,
            kb_size: tag.tag_attachment.blank? ? 0 : tag.tag_attachment.file.byte_size/1024,
            bootstrap: tag.try(:bootstrap),
            force_update: tag.try(:force_update),
            content: tag.try(:content)
          }
          _tags << _hash
        end
      end
      tag_hash = {code: "00", message: "客户端需要更新", result: _tags}
      render json: tag_hash, status: 200
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
        @tag_attachment = @tags.first.tag_attachment
        return render_json(code: "03", message: "版本附件不存在", status: 200) if @tag_attachment.blank?
        
        tag_hash = {code: "", version: "", tag_attachment: ""}
        @tags.each do |tag|
          _categories = []
          categories = tag.tag_attachment.categories
          categories.each do |categorie|
            categories_hash = {
              name: categorie.text,
              url: categorie.mark==1 ? "" : "http://139.198.123.199/products/#{categorie.tag_attachment.tag.product_id}/tags/#{categorie.tag_attachment.tag_id}/#{categorie.relative_path}",
              attachment_path: categorie.relative_path,
              created_at: categorie.created_at.strftime('%Y-%m-%d %H:%M')
            }
          _categories << categories_hash
          end

          tag_hash = {
            name: tag.product.name,
            version: "Ver_#{tag.name}",
            kb_size: tag.tag_attachment.file.byte_size/1024,
            bootstrap: tag.try(:bootstrap),
            force_update: tag.try(:force_update),
            tag_attachment: _categories
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