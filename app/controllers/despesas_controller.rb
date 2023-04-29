class DespesasController < ApplicationController
  before_action :require_logged_in_user
  before_action :set_despesa, only: %i[ show edit update destroy ]
  include Pagy::Backend

  # GET /despesas or /despesas.json
  def index
    @despesas = Despesa.where.not(tipo: "FUNCIONÁRIO").order(:data)
    @despesas_maior_valor2 = @despesas.maximum(:valor)
    @despesa_fixa_func = Despesa.where(tipo: "FUNCIONÁRIO")
    @user = User.where(desligamento: "01-01-3000").where(tipo: "FUNCIONÁRIO")
   
    
    
    if params[:mes_select]
      user_ids = User.where(tipo: "FUNCIONÁRIO").where("to_char(date_trunc('month', created_at), 'YYYY-MM') <= '#{params[:mes_select]}' AND to_char(date_trunc('month', desligamento), 'YYYY-MM') >= '#{params[:mes_select]}'").pluck(:id)
      @mes = params[:mes_select]
      ano = @mes.split("-")[0].to_i
      mes = @mes.split("-")[1].to_i
      
      @despesas = Despesa.where.not(tipo: "FUNCIONÁRIO").where("DATE_PART('year', data) = ? AND DATE_PART('month', data) = ?", ano, mes).order(:data)
      @despesa_fixa_func = Despesa.where(tipo: "FUNCIONÁRIO").where("to_char(date_trunc('month', data), 'YYYY-MM') <= '#{params[:mes_select]}'").where(funcionario: user_ids)
      @despesa_mensal = @despesas + @despesa_fixa_func
      @despesas_total = @despesa_mensal.map(&:valor).sum
      @despesas_total_qnt = @despesa_mensal.count
      #@despesas_maior_valor = @despesa_mensal.order(valor: :desc).limit(1)
      @despesas_maior_valor2 = @despesas.maximum(:valor)
      #binding.pry
    else
      @despesa_mensal = @despesas + @despesa_fixa_func
      @despesas_total_qnt = @despesa_mensal.count
      @despesas_total = @despesa_mensal.map(&:valor).sum
      @despesas_maior_valor = @despesa_mensal.max_by(&:valor)
    end

     @pagy, @despesas = pagy(@despesas)
  end

  def mensal    
    @despesas = Despesa.where(data: Time.now.beginning_of_month..Time.now.end_of_month).order(:data)
    
    @despesas_total = @despesas.sum(:valor)
    @despesas_total_qnt = @despesas.count
    @despesas_maior_valor = @despesas.max_by(&:valor)
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
    @users_func = User.where(tipo: ["FUNCIONÁRIO", "FUNCIONARIO COM ACESSO"]).where(desligamento: "01-01-3000")
  end

  # GET /despesas/1/edit
  def edit
    @users = User.all
    @users_func = User.where(tipo: ["FUNCIONÁRIO", "FUNCIONARIO COM ACESSO"]).where(desligamento: "01-01-3000")
  end

  # POST /despesas or /despesas.json
  def create
    @users = User.all
    @users_func = User.where(tipo: ["FUNCIONÁRIO", "FUNCIONARIO COM ACESSO"]).where(desligamento: "01-01-3000")
    params[:despesa][:valor] = params[:despesa][:valor].gsub('R$','').gsub(' ','').gsub('.','')
    @despesa = Despesa.new(despesa_params)
#binding.pry
    if Despesa.where(tipo: "FUNCIONÁRIO").where(tipo: params[:despesa][:tipo]).where(funcionario: params[:despesa][:funcionario]).present?
      flash[:danger] = "Despesa de funcionário já cadastrada, edite a existente!" 
      redirect_to despesas_path
    else
      if @despesa.save
        flash[:success] = "Despesa criada com sucesso!" 
        redirect_to despesas_path
      else
        flash[:danger] = "Despesa não foi criada!"
        render 'new'
      end
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
      params.require(:despesa).permit(:observacao, :tipo, :valor, :data, :vale, :funcionario, :user_id)
    end
end
