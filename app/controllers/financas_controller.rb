class FinancasController < ApplicationController
  before_action :require_logged_in_user
  def index
    @nome=12
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
    @despesas_produtos_mes = @despesas.where(tipo: "PRODUTOS").where(data: Time.now.beginning_of_month..Time.now.end_of_month).sum(:valor)
    @despesas_geral_mes = @despesas.where.not(tipo: "PRODUTOS").where(data: Time.now.beginning_of_month..Time.now.end_of_month).sum(:valor)
    
    if params[:mes_select]
      @mes = params[:mes_select] || Time.now.month
      @servicos_mensal = @servicos.where("DATE_PART('month', data) = ?", @mes) if params[:mes_select].present?
      @despeses_mes = @despesas.where("DATE_PART('month', data) = ?", @mes).sum(:valor)
      @servicos_total = @servicos_mensal.map(&:valor).sum
      @servicos_lucro = @servicos_total - @despeses_mes
      @servicos_quantidade_mes = @servicos_mensal.count
      @despesas_produtos_mes =  @despesas.where("DATE_PART('month', data) = ?", @mes).where(tipo: "PRODUTOS").sum(:valor)
      @despesas_geral_mes =  @despesas.where("DATE_PART('month', data) = ?", @mes).where.not(tipo: "PRODUTOS").sum(:valor)
      @ticketmedio_mes = @servicos_lucro / @servicos_quantidade_mes if @servicos_quantidade_mes != 0 
    else
      @ticketmedio_mes = @servicos_lucro / @servicos_quantidade_mes if @servicos_quantidade_mes != 0
    end
  end

  def individual
  end

end
