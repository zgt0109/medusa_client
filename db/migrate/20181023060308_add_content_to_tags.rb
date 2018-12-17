class AddContentToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :content, :text, comment: "版本更新内容"
  end
end
