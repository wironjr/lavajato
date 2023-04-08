class DespesasController < ApplicationController
  before_action :require_logged_in_user
  before_action :set_despesa, only: %i[ show edit update destroy ]
  include Pagy::Backend

  # GET /despesas or /despesas.json
  def index
    @despesas = Despesa.all.order(:data)
    @despesas_total = @despesas.sum(:valor)
    @despesas_total_qnt = @despesas.count
    @despesas_maior_valor = @despesas.order(valor: :desc).limit(1)
    @despesas_maior_valor2 = @despesas.maximum(:valor)
    
    @pagy, @despesas = pagy(@despesas)
    #binding.pry
    
  end

  def mensal
    @despesas = Despesa.where(data: Time.now.beginning_of_month..Time.now.end_of_month).order(:data)
    @despesas_total = @despesas.sum(:valor)
    @despesas_total_qnt = @despesas.count
    @despesas_maior_valor = @despesas.order(valor: :desc).limit(1)
    @despesas_maior_valor2 = @despesas.maximum(:valor)

    @despesa_vale_qnt = @despesas.where(tipo: "VALE").count
    @despesa_vale_valor = @despesas.where(tipo: "VALE").sum(:valor)
    
    @despesa_produto_qnt = @despesas.where(tipo: "PRODUTOS").count
    @despesa_produto_valor = @despesas.where(tipo: "PRODUTOS").sum(:valor)
    
    @despesa_func_qnt = @despesas.where(tipo: "FUNCIONÁRIO").count
    @despesa_func_valor = @despesas.where(tipo: "FUNCIONÁRIO").sum(:valor)

    @pagy, @despesas = pagy(@despesas)
  end


  def vale
    @despesas = Despesa.where(tipo: "VALE").order(:data)
    @despesas_total = @despesas.sum(:valor)
    @despesas_total_qnt = @despesas.count
    @pagy, @despesas = pagy(@despesas)
  end
  
  def produtos
    @despesas = Despesa.where(tipo: "PRODUTOS").order(:data)
    @despesas_total = @despesas.sum(:valor)
    @despesas_total_qnt = @despesas.count
    @pagy, @despesas = pagy(@despesas)
  end

  def geral
    @despesas = Despesa.where.not(tipo: ["PRODUTOS", "VALE"]).order(:data)
    @despesas_total = @despesas.sum(:valor)
    @despesas_total_qnt = @despesas.count
    @pagy, @despesas = pagy(@despesas)
  end

  # GET /despesas/new
  def new
    @despesa = Despesa.new
    @users = User.all
    @users_func = User.where(tipo: ["FUNCIONÁRIO", "FUNCIONARIO COM ACESSO"])
  end

  # GET /despesas/1/edit
  def edit
    @users = User.all
    @users_func = User.where(tipo: ["FUNCIONÁRIO", "FUNCIONARIO COM ACESSO"])
  end

  # POST /despesas or /despesas.json
  def create
    @users = User.all
    @users_func = User.where(tipo: ["FUNCIONÁRIO", "FUNCIONARIO COM ACESSO"])
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
    @users = User.all
    @users_func = User.where(tipo: ["FUNCIONÁRIO", "FUNCIONARIO COM ACESSO"])
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
      params.require(:despesa).permit(:observacao, :tipo, :valor, :data, :vale, :funcionario)
    end
end
