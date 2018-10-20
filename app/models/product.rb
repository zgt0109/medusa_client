# == Schema Information
#
# Table name: products
#
#  id           :bigint(8)        not null, primary key
#  name(软件名称)   :string(50)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_products_on_name  (name)
#

class Product < ApplicationRecord
    has_many :tags
end
