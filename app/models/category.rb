# == Schema Information
#
# Table name: categories
#
#  id                      :bigint(8)        not null, primary key
#  ancestry                :string(255)
#  deleted_at(删除时间)        :datetime
#  file_name(文件名)          :string(255)
#  kb_size                 :integer
#  relative_path(文件相对路径)   :string(255)
#  text                    :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  tag_attachment_id(所属版本) :bigint(8)
#
# Indexes
#
#  index_categories_on_ancestry           (ancestry)
#  index_categories_on_tag_attachment_id  (tag_attachment_id)
#
# Foreign Keys
#
#  fk_rails_...  (tag_attachment_id => tag_attachments.id)
#

class Category < ApplicationRecord
  has_ancestry
  belongs_to :tag_attachment
end
