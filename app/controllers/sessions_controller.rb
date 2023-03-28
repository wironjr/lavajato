class SessionsController < ApplicationController
  def new
    redirect_to root_path if user_signed_in?
  end

  def create
    user = User.find_by(nome: params[:session][:nome].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in(user)
      redirect_to root_path
    else
      flash[:danger] = 'Nome ou senha inválidos'
      redirect_to entrar_path
    end
  end

  def destroy
    sign_out
    flash[:success] = 'Logout com sucesso!'
    redirect_to entrar_path
  end
end
