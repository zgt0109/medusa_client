class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories, comment: "结构分类" do |t|
      t.references :tag_attachment, foreign_key: true, comment: "所属版本"
      t.string :title, comment: "分类名"
      t.string :file_name, comment: "文件名"
      t.string :relative_path, comment: "文件相对路径"
      t.datetime :deleted_at, comment: "删除时间"

      t.timestamps
    end
  end
end