class RemoveDeletedAtFromProductsTags < ActiveRecord::Migration[5.2]
  def change
    remove_column :categories, :deleted_at, :datetime
    remove_column :products, :deleted_at, :datetime
    remove_column :tags, :deleted_at, :datetime
    remove_column :tag_attachments, :deleted_at, :datetime
  end
end
