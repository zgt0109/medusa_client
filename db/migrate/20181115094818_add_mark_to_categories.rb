class AddMarkToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :mark, :integer, comment: "标记(1目录,2文件)"
  end
end
