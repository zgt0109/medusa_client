class AddBootstrapToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :bootstrap, :string, comment: "主程序路径"
    add_column :tags, :force_update, :boolean, comment: "强制更新"
  end
end
