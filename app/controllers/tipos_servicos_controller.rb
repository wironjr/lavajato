class TiposServicosController < ApplicationController
  before_action :require_logged_in_user
  before_action :set_tipos_servico, only: %i[ show edit update destroy ]
  include Pagy::Backend

  # GET /tipos_servicos or /tipos_servicos.json
  def index
    @tipos_servicos = TiposServico.all

    if params[:tipo_select].present?
      @tipos_servicos = @tipos_servicos.where('tipo ILIKE ?', "%#{params[:tipo_select]}%")
    end

    @pagy, @tipos_servicos = pagy(@tipos_servicos)
  end

  # GET /tipos_servicos/1 or /tipos_servicos/1.json
  def show
  end

  # GET /tipos_servicos/new
  def new
    @tipos_servico = TiposServico.new
  end

  # GET /tipos_servicos/1/edit
  def edit
  end

  # POST /tipos_servicos or /tipos_servicos.json
  def create
    @tipos_servico = TiposServico.new(tipos_servico_params)

    if @tipos_servico.save
      flash[:success] = "Tipo de serviço criado com sucesso!" 
      redirect_to tipos_servicos_path
    else
      flash[:danger] = "Tipo de serviço não foi apagado!" 
      redirect_to tipos_servicos_path
    end
  end

  # PATCH/PUT /tipos_servicos/1 or /tipos_servicos/1.json
  def update
      if @tipos_servico.update(tipos_servico_params)
        flash[:success] = "Tipo de serviço editado com sucesso!" 
        redirect_to tipos_servicos_path
      else
        flash[:danger] = "Tipo de serviço não foi editado!" 
        redirect_to tipos_servicos_path
      end
  end

  # DELETE /tipos_servicos/1 or /tipos_servicos/1.json
  def destroy
    @tipos_servico.destroy

    flash[:success] = "Tipo de serviço apagado com sucesso!" 
    redirect_to tipos_servicos_path
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipos_servico
      @tipos_servico = TiposServico.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tipos_servico_params
      params.require(:tipos_servico).permit(:tipo)
    end
end
