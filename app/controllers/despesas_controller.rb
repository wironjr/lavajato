class DespesasController < ApplicationController
  before_action :require_logged_in_user
  before_action :set_despesa, only: %i[ show edit update destroy ]

  # GET /despesas or /despesas.json
  def index
    @despesas = Despesa.all
    @despesas_total = @despesas.sum(:valor)
    @despesas_total_qnt = @despesas.count
    @despesas_maior_valor = @despesas.order(valor: :desc).limit(1)
    @despesas_maior_valor2 = @despesas.maximum(:valor)
    
    #binding.pry
    
  end
  
  # GET /despesas/1 or /despesas/1.json
  def show
  end
  
  def produtos
    @despesas = Despesa.where(tipo: "PRODUTOS")
    @despesas_total = @despesas.sum(:valor)
    @despesas_total_qnt = @despesas.count
  end

  def geral
    @despesas = Despesa.where.not(tipo: "PRODUTOS")
    @despesas_total = @despesas.sum(:valor)
    @despesas_total_qnt = @despesas.count
  end

  # GET /despesas/new
  def new
    @despesa = Despesa.new
  end

  # GET /despesas/1/edit
  def edit
  end

  # POST /despesas or /despesas.json
  def create
    params[:despesa][:valor] = params[:despesa][:valor].gsub('R$','').gsub(' ','').gsub('.','')
    @despesa = Despesa.new(despesa_params)
    
      if @despesa.save
        flash[:success] = "Despesa criada com sucesso!" 
        redirect_to despesas_path
      else
        flash[:danger] = "Despesa não foi criada!"
        render 'new'
      end

  end

  # PATCH/PUT /despesas/1 or /despesas/1.json
  def update
    params[:despesa][:valor] = params[:despesa][:valor].gsub('R$','').gsub(' ','').gsub('.','')
   
      if @despesa.update(despesa_params)
        flash[:success] = "Despesa editada com sucesso!" 
        redirect_to despesas_path
      else
        flash[:danger] = "Despesa não foi editada!" 
        render 'new'
      end
    
  end

  # DELETE /despesas/1 or /despesas/1.json
  def destroy
    @despesa.destroy

    flash[:success] = "Depesa apagada com sucesso!" 
    redirect_to despesas_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_despesa
      @despesa = Despesa.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def despesa_params
      params.require(:despesa).permit(:observacao, :tipo, :valor, :data)
    end
end
