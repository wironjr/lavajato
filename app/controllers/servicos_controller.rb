class ServicosController < ApplicationController
  before_action :require_logged_in_user
  before_action :set_servico, only: %i[ show edit update destroy ]

  # GET /servicos or /servicos.json
  def index
    @servicos = Servico.all
    @servicos_do_dia = @servicos.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'")
  end

  def todos
    @servicos = Servico.all
  end

  # GET /servicos/1 or /servicos/1.json
  def show
  end

  # GET /servicos/new
  def new
    @servico = Servico.new
  end

  # GET /servicos/1/edit
  def edit
  end

  # POST /servicos or /servicos.json
  def create
    params[:servico][:valor] = params[:servico][:valor].gsub('R$','').gsub(' ','')

    @servico = Servico.new(servico_params)

  
    if @servico.save
      flash[:success] = "Serviço criado com sucesso!" 
      redirect_to servicos_path
    else
      render 'new'
    end
    
  end

  # PATCH/PUT /servicos/1 or /servicos/1.json
  def update
    params[:servico][:valor] = params[:servico][:valor].gsub('R$','').gsub(' ','')
   
      if @servico.update(servico_params)
        flash[:success] = "Serviço atualizado com sucesso!" 
        redirect_to servicos_path
      else
        render 'new'
      end
    
  end

  # DELETE /servicos/1 or /servicos/1.json
  def destroy
    @servico.destroy

    flash[:success] = "Serviço apagado com sucesso!" 
    redirect_to servicos_path
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_servico
      @servico = Servico.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def servico_params
      params.require(:servico).permit(:cliente, :data, :servico, :valor, :caixa, :pago)
    end
end
