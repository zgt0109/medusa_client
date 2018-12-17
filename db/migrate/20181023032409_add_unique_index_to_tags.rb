class AddUniqueIndexToTags < ActiveRecord::Migration[5.2]
  def change
    add_index :tags, [:name, :product_id], unique: true
  end
end
