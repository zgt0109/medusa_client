# == Schema Information
#
# Table name: tags
#
#  id                  :bigint(8)        not null, primary key
#  content(版本更新内容)     :text(65535)
#  is_public(是否发布)     :boolean          default(FALSE)
#  name(版本名称)          :string(50)
#  remote_ip(ip白名单)    :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  product_id(客户端产品id) :bigint(8)
#
# Indexes
#
#  index_tags_on_name                 (name)
#  index_tags_on_name_and_product_id  (name,product_id) UNIQUE
#  index_tags_on_product_id           (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#

class Tag < ApplicationRecord
  validates :name, presence: {message: "不能为空"}, uniqueness: { scope: :product_id, message: "已经存在"}
  validates :content, presence: {message: "不能为空"}
  belongs_to :product
  has_one :tag_attachment, dependent: :destroy

  scope :which_product, ->(product) { where(:product_id => product) unless product.blank? }

  validate :limit_remote_ip_size, on: [:create, :update]

  after_destroy :destroy_all

  def destroy_all
    # 删除版本附带删除版本下面上传的附件
    attachments_path = "#{Rails.root}/public/products/#{self.product_id}/tags/#{self.id}/"
    extract_directory = attachments_path
    FileUtils.rm_rf(extract_directory) if File.exist?(extract_directory)
  end
 
  def limit_remote_ip_size
    if remote_ip.present?
      errors.add(:remote_ip, "IP地址最多为10个") if remote_ip.strip.split(',').size > 10
    end
  end

  def return_yes_or_no(tag)
    tag.is_public.present? ? "是" : "否"
  end
end
