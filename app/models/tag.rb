# == Schema Information
#
# Table name: tags
#
#  id                  :bigint(8)        not null, primary key
#  deleted_at(删除时间)    :datetime
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
  acts_as_paranoid

  validates :name, presence: {message: "不能为空"}, uniqueness: { scope: :product_id, message: "已经存在"}
  validates :content, presence: {message: "不能为空"}
  belongs_to :product
  has_many :tag_attachments

  scope :which_product, ->(product) { where(:product_id => product) unless product.blank? }

  validate :limit_remote_ip_size, on: [:create, :update]
 
  def limit_remote_ip_size
    if remote_ip.present?
      errors.add(:remote_ip, "IP地址最多为10个") if remote_ip.strip.split(',').size > 10
    end
  end

  def return_yes_or_no(tag)
    tag.is_public.present? ? "是" : "否"
  end
end
