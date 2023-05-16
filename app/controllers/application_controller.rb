class ApplicationController < ActionController::Base
	include SessionsHelper

	private
	def require_logged_in_user
		unless user_signed_in?
			flash[:danger] = 'Precisa estar logado para acessar!'
			redirect_to entrar_path
		end
	end    
end
