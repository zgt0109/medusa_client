class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags, comment: "版本管理" do |t|
      t.references :product, foreign_key: true, comment: "客户端产品id"
      t.string :name, limit: 50, comment: "版本名称"
      t.boolean :is_public, comment: "是否发布"
      t.string :remote_ip, comment: "ip白名单"
      t.datetime :deleted_at, comment: "删除时间"

      t.timestamps
    end
  end
end