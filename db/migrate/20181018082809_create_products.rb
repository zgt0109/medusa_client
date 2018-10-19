class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products, comment: "客户端软件产品" do |t|
      t.string :name, limit: 50, comment: "软件名称"

      t.timestamps
    end
    add_index :products, :name
  end
end
