class UsersController < ApplicationController
  before_action :require_logged_in_user
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    
      if @user.save
        flash[:success] = "Usuário criado com sucesso!" 
        redirect_to users_path
      else
        render 'new'
      end
   
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    
      if @user.update(user_params)
        flash[:success] = "Usuário editado com sucesso!" 
        redirect_to users_path
      else
        render 'new'
      end
    
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    
    flash[:success] = "Usuário apagado com sucesso!" 
    redirect_to users_path
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:nome, :password, :password_confirmation)
    end
end
