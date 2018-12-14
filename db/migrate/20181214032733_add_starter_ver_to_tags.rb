class AddStarterVerToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :starter_ver, :string, limit: 50, after: :name, comment: "启动器版本"
  end
end
