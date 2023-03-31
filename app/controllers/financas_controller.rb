class FinancasController < ApplicationController
  before_action :require_logged_in_user
  
  def index
    @servicos = Servico.all
    @despesas = Despesa.all
    @servicos_total = @servicos.where(pago: :true).map(&:valor).sum
    @despeses_mes = @despesas.sum(:valor)
    @servicos_lucro = @servicos_total - @despeses_mes
    @servicos_quantidade = @servicos.count
    @despesas_valor = @despesas.sum(:valor)
    
    @despesas_produtos_mes = @despesas.where(tipo: "PRODUTOS").sum(:valor)
    @despesas_geral_mes = @despesas.where.not(tipo: "PRODUTOS").sum(:valor)

    @ticketmedio_mes = @servicos_lucro / @servicos_quantidade if @servicos_quantidade != 0
    @despesas_media_valor = @despesas_valor / @despesas.count if @despesas.count > 0
    
  end

  def mensal
    @servicos = Servico.all
    @despesas = Despesa.all
    @servicos_total = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(pago: :true).map(&:valor).sum
    @despeses_mes = @despesas.where(data: Time.now.beginning_of_month..Time.now.end_of_month).sum(:valor)
    @servicos_lucro = @servicos_total - @despeses_mes
    @servicos_quantidade_mes = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month).count
    @servicos_pago_pendedente = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(pago: :false).count
    @servicos_mensal = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month)
    @despesas_mensal = @despesas.where(data: Time.now.beginning_of_month..Time.now.end_of_month)
    @despesas_valor = @despesas_mensal.sum(:valor)
    
    @despesas_produtos_mes = @despesas.where(tipo: "PRODUTOS").where(data: Time.now.beginning_of_month..Time.now.end_of_month).sum(:valor)
    @despesas_geral_mes = @despesas.where.not(tipo: "PRODUTOS").where(data: Time.now.beginning_of_month..Time.now.end_of_month).sum(:valor)
    
    if params[:mes_select]
      @mes = params[:mes_select] || Time.now.month
      @servicos_mensal = @servicos.where("DATE_PART('month', data) = ?", @mes) if params[:mes_select].present?
      @despesas_mensal = @despesas.where("DATE_PART('month', data) = ?", @mes) if params[:mes_select].present?
      @despeses_mes = @despesas.where("DATE_PART('month', data) = ?", @mes).sum(:valor)
      @despesas_valor = @despesas_mensal.sum(:valor)
      @despesas_media_valor = @despesas_valor / @despesas_mensal.count if @despesas_mensal.count > 0 
      @servicos_total = @servicos_mensal.map(&:valor).sum
      @servicos_lucro = @servicos_total - @despeses_mes
      @servicos_quantidade_mes = @servicos_mensal.count
      @despesas_produtos_mes =  @despesas.where("DATE_PART('month', data) = ?", @mes).where(tipo: "PRODUTOS").sum(:valor)
      @despesas_geral_mes =  @despesas.where("DATE_PART('month', data) = ?", @mes).where.not(tipo: "PRODUTOS").sum(:valor)
      @ticketmedio_mes = @servicos_lucro / @servicos_quantidade_mes if @servicos_quantidade_mes != 0 
    else
      @ticketmedio_mes = @servicos_lucro / @servicos_quantidade_mes if @servicos_quantidade_mes != 0
      @despesas_media_valor = @despesas_valor / @despesas_mensal.count if @despesas_mensal.count > 0
    end
  end

  def individual
    @users = User.all
    @despesas = Despesa.all
    @servicos = Servico.all

    ##### qnt de usuarios #####
    @users_quantidade = @users.count

    ##### lucro ######
    @servicos_total = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(pago: :true).map(&:valor).sum
    @despeses_mes = @despesas.where(data: Time.now.beginning_of_month..Time.now.end_of_month).sum(:valor)
    @servicos_lucro = @servicos_total - @despeses_mes
    @servicos_lucro_individual =  @servicos_lucro / @users_quantidade

    @users.each do |usuario|
      recebido_usuario = Servico.where(caixa: usuario.nome.upcase).sum(:valor)
      falta_receber = @servicos_lucro_individual - recebido_usuario
      instance_variable_set("@recebido_#{usuario.nome}", recebido_usuario)
      instance_variable_set("@falta_receber_#{usuario.nome}", falta_receber)
      #binding.pry
    end
    
    
  end

end
