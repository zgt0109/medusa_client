# == Schema Information
#
# Table name: tag_attachments
#
#  id                      :bigint(8)        not null, primary key
#  attachment_path(附件相对路径) :string(255)
#  file(文件)                :string(255)
#  name(名字)                :string(255)
#  remark(备注)              :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  tag_id(所属版本号)           :bigint(8)
#
# Indexes
#
#  index_tag_attachments_on_tag_id  (tag_id)
#
# Foreign Keys
#
#  fk_rails_...  (tag_id => tags.id)
#

class TagAttachment < ApplicationRecord
  belongs_to :tag
  has_one_attached :file
  has_many :categories, dependent: :destroy

  scope :which_tag, ->(tag) { where(:tag_id => tag) unless tag.blank? }

  validate :check_file, on: :create

  after_create :g_zip_file

  private 
  def check_file
    if self.name.split('.').last != 'zip'
      errors.add(:file, "请上传后缀为zip的压缩包")
    end
  end

  def g_category(file_path, which_type)
    split_path = file_path.split('/')
    if which_type == 1
      if split_path.size == 1
        Category.find_or_create_by(text: split_path.first, file_name: split_path.first, relative_path: file_path, tag_attachment_id: self.id, mark: which_type)
      else
        p_category = Category.find_by(text: split_path.at(split_path.size-2), tag_attachment_id: self.id)
        p_category.children.create(text: split_path.at(split_path.size-1), file_name: split_path.at(split_path.size-1), relative_path: file_path, tag_attachment_id: self.id, mark: which_type)
      end
    else
      p_category = Category.find_by(text: split_path.at(split_path.size-2), tag_attachment_id: self.id)
      p_category.children.create(text: split_path.at(split_path.size-1), file_name: split_path.at(split_path.size-1), relative_path: file_path, tag_attachment_id: self.id, mark: which_type)
    end
  end

  def g_zip_file
    # "#{Rails.root}/storage/dY/Cx/dYCx5pvA879Zc4WPVN3DDToz"
    key = self.file.key
    attachments_path = "#{Rails.root}/public/products/#{self.tag.product_id}/tags/#{self.tag_id}/"
    extract_directory = attachments_path
    FileUtils.mkdir_p(extract_directory) unless File.exist?(extract_directory)

    ActiveRecord::Base.transaction do
      begin
        Zip::File.open("#{Rails.root}/storage/#{key.first(2)}/#{key.first(4).last(2)}/#{key}") do |zip_file|
          zip_file.each do |entry|
            next if entry.name =~ /__MACOSX/ or entry.name =~ /\.DS_Store/
            if entry.directory?
              logger.info "创建目录" 
              entry.extract(File.join(extract_directory, entry::name))
              g_category(entry.name, 1)
            else
              logger.info "创建文件" 
              entry.extract(File.join(extract_directory, entry::name))
              g_category(entry.name, 2)
            end
          end
        end
      rescue
        FileUtils.rm_rf(extract_directory)
        # 删除相关文件
        self.destroy
        logger.info "创建目录失败，删除新增文件"
      end
    end

    logger.info "解压文件完成！"
    
  end
end
# 创建目录
# 解压文件wangyuexing/......
# 创建目录
# 解压文件wangyuexing/config/......
# 创建目录
# 解压文件wangyuexing/config/config1/......
# 创建文件
# 解压文件wangyuexing/config/config1/1.txt......
# 创建文件
# 解压文件wangyuexing/2.txt......
# 创建目录
# 解压文件wangyuexing/data/......
# 创建文件
# 解压文件wangyuexing/data/icon.png......
# 创建文件
# wangyuexing/data/学生分班表格.xlsx
