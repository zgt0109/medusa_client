puts "创建软件产品"
product1 = Product.create(name: '赛多分')
puts "用户名：#{product1.name}"

product2 = Product.create(name: '网悦星')
puts "用户名：#{product2.name}"