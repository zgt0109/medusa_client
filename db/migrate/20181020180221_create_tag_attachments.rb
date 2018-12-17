class CreateTagAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_attachments, comment: "版本文件" do |t|
      t.references :tag, foreign_key: true, comment: "所属版本号"
      t.string :name, comment: "名字"
      t.string :file, comment: "文件"
      t.string :remark, comment: "备注"
      t.string :attachment_path, comment: "附件相对路径"
      t.datetime :deleted_at, comment: "附件删除时间"

      t.timestamps
    end
  end
end