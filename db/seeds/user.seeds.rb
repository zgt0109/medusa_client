puts "创建管理员"
user = User.create(email: 'thrive', password: "123456", password_confirmation: "123456", salt: 1)
puts "用户名：#{user.email}，密码：123456"