class AddDepthToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :kb_size, :int
    rename_column :categories, :title, :text
  end
end
