# == Schema Information
#
# Table name: tag_attachments
#
#  id                      :bigint(8)        not null, primary key
#  attachment_path(附件相对路径) :string(255)
#  deleted_at(附件删除时间)      :datetime
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
  acts_as_paranoid
  
  belongs_to :tag
  has_one_attached :file

  scope :which_tag, ->(tag) { where(:tag_id => tag) unless tag.blank? }
end