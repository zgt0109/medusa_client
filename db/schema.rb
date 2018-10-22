# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_10_22_022318) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "结构分类", force: :cascade do |t|
    t.bigint "tag_id", comment: "所属版本"
    t.string "title", comment: "分类名"
    t.string "file_name", comment: "文件名"
    t.string "relative_path", comment: "文件相对路径"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.index ["ancestry"], name: "index_categories_on_ancestry"
    t.index ["tag_id"], name: "index_categories_on_tag_id"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "客户端软件产品", force: :cascade do |t|
    t.string "name", limit: 50, comment: "软件名称"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_products_on_name"
  end

  create_table "tag_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "版本文件", force: :cascade do |t|
    t.bigint "tag_id", comment: "所属版本号"
    t.string "name", comment: "名字"
    t.string "file", comment: "文件"
    t.string "remark", comment: "备注"
    t.string "attachment_path", comment: "附件相对路径"
    t.datetime "deleted_at", comment: "附件删除时间"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_tag_attachments_on_tag_id"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "版本管理", force: :cascade do |t|
    t.bigint "product_id", comment: "客户端产品id"
    t.string "name", limit: 50, comment: "版本名称"
    t.boolean "is_public", default: false, comment: "是否发布"
    t.string "remote_ip", comment: "ip白名单"
    t.datetime "deleted_at", comment: "删除时间"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name"
    t.index ["product_id"], name: "index_tags_on_product_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "管理员", force: :cascade do |t|
    t.string "name", limit: 50
    t.string "email", limit: 100, comment: "用户名"
    t.string "crypted_password", comment: "密码"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "activation_state"
    t.string "activation_token"
    t.datetime "activation_state_expires_at"
    t.index ["activation_token"], name: "index_users_on_activation_token"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "categories", "tags"
  add_foreign_key "tag_attachments", "tags"
  add_foreign_key "tags", "products"
end
