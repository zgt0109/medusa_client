class SorceryUser < ActiveRecord::Migration[5.2]
  def change
    create_table :users, comment: "管理员" do |t|
      t.string :name, limit: 50
      t.string :email, limit: 100, comment: "用户名"
      t.string :crypted_password, comment: "密码"
      t.string :salt

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
