class LogoImagemsController < ApplicationController
  before_action :require_logged_in_user
  before_action :set_logo_imagem, only: %i[ show edit update destroy apagar_foto]

  # GET /logo_imagems or /logo_imagems.json
  def index
    @logo_imagems = LogoImagem.all
  end

  # GET /logo_imagems/1 or /logo_imagems/1.json
  def show
  end

  # GET /logo_imagems/new
  def new
    @logo_imagem = LogoImagem.new
  end

  # GET /logo_imagems/1/edit
  def edit
  end

  # POST /logo_imagems or /logo_imagems.json
  def create
    @logo_imagem = LogoImagem.new(logo_imagem_params)

    if @logo_imagem.save
      flash[:success] = "Logo salva com sucesso!" 
      redirect_to logo_imagems_path
    else
      flash[:danger] = "Logo não foi salva!" 
      redirect_to logo_imagems_path
    end
    
  end

  # PATCH/PUT /logo_imagems/1 or /logo_imagems/1.json
  def update
    if @logo_imagem.update(logo_imagem_params)
      flash[:success] = "Logo editada com sucesso!" 
      redirect_to logo_imagems_path
    else
      flash[:danger] = "Logo não foi editada!" 
      redirect_to logo_imagems_path
    end
  end

  def apagar_foto
    @logo_imagem.imagem.purge
    redirect_back(fallback_location: root_path)
  end

  # DELETE /logo_imagems/1 or /logo_imagems/1.json
  def destroy
    @logo_imagem.destroy

    flash[:success] = "Logo apagada com sucesso!" 
    redirect_to logo_imagems_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_logo_imagem
      @logo_imagem = LogoImagem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def logo_imagem_params
      params.require(:logo_imagem).permit(:imagem, :nome)
    end
end
