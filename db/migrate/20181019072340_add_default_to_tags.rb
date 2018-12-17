class AddDefaultToTags < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tags, :is_public, from: nil, to: false
  end
end
