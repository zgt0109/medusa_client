class SessionsController < ApplicationController
  layout "login"
  before_action :auth_user, except: :destroy

  def new
  end

  def create
    #login是sorcery的登录方法
    if user = login(params[:email], params[:password])
      flash[:notice] = '登陆成功'
      redirect_to products_path
    else
      flash[:notice] = '帐号或者密码错误'
      render 'new'
    end
  end

  def destroy
    #logout是sorcery的退出方法
    logout
    flash[:notice] = '退出成功'
    redirect_to root_path
  end

  private def auth_user
    if logged_in?
      redirect_to products_path
    end
  end
end
