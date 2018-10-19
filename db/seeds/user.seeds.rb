puts "创建管理员"
user = User.create(name: 'thrive', password: "123456", password_confirmation: "123456")
puts "用户名：#{user.name}，密码：#{user.password}"