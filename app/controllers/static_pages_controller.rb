class StaticPagesController < ApplicationController
  before_action :require_logged_in_user
  def index
    @nome = "Wiron"
    @servicos = Servico.all
    @despesas = Despesa.all
    @servicos_total = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(pago: :true).map(&:valor).sum
    @servicos_total_modal = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(pago: :true)
    @servicos_lucro = @servicos_total - @despesas.where(data: Time.now.beginning_of_month..Time.now.end_of_month).sum(:valor)
    @servicos_quantidade_mes = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month).count
    @servicos_pago_pendedente = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(pago: :false).count
    @despesas_mes = @despesas.where(data: Time.now.beginning_of_month..Time.now.end_of_month).sum(:valor)
    @despesas_mes_modal = @despesas.where(data: Time.now.beginning_of_month..Time.now.end_of_month)

    @ultimos_servicos = @servicos.order(data: :desc).limit(3)
    @ultimos_despesas = @despesas.order(data: :desc).limit(3)
    
    
    
    start_date = 3.months.ago.beginning_of_month
    end_date = Time.now.end_of_month
      
      services_data = Servico
        .select("DATE_TRUNC('month', data) as month, COUNT(*) as count, SUM(valor) as total")
        .where(data: start_date..end_date, pago: true)
        .group("1")
        .order("1")

      expenses_data = Despesa
        .select("DATE_TRUNC('month', data) as month, SUM(valor) as total")
        .where(data: start_date..end_date)
        .group("1")
        .order("1")

      merged_data = services_data.map do |service|
        expenses = expenses_data.find { |expense| expense.month == service.month }
        expenses_total = expenses ? expenses.total : 0
        { month: service.month, count: service.count, total: service.total, expenses: expenses_total }
      end

      @categories = merged_data.map { |s| I18n.l(s[:month], format: '%B') }
      @services_data = merged_data.map { |s| s[:count] }
      @profit_data = merged_data.map { |s| s[:total] - s[:expenses] }
      @expenses_data = merged_data.map { |s| s[:expenses] }
  end
end
