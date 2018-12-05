# == Schema Information
#
# Table name: products
#
#  id           :bigint(8)        not null, primary key
#  name(软件名称)   :string(50)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_products_on_name  (name)
#

class Product < ApplicationRecord
    has_many :tags, dependent: :destroy
    validates :name, presence: {message: "不能为空"}, uniqueness: {message: "已经存在"}

    after_destroy :destroy_all

    def destroy_all
      # 删除产品下面的所有版本以及 版本附带删除版本下面上传的附件
      attachments_path = "#{Rails.root}/public/products/#{self.id}"
      extract_directory = attachments_path
      FileUtils.rm_rf(extract_directory) if File.exist?(extract_directory)

      # 删除storage下面的所有版本tag文件
      self.tags do |tag|
        key = tag.tag_attachment.file.key
        storage_file_path = "#{Rails.root}/storage/#{key.first(2)}/#{key.first(4).last(2)}/#{key}"
        FileUtils.rm_rf(storage_file_path) if File.exist?(storage_file_path)
      end
    end
end
