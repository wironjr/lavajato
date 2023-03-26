class StaticPagesController < ApplicationController
    before_action :require_logged_in_user
    def index
        @nome = "Wiron"
        @servicos = Servico.all
        @servicos_total = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(pago: :true).map(&:valor).sum
        @servicos_quantidade_mes = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month).count
        @servicos_pago_pendedente = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(pago: :false).count
        
        start_date = 3.months.ago.beginning_of_month
        end_date = Time.now.end_of_month
        
        services_data = Servico
          .select("DATE_TRUNC('month', data) as month, COUNT(*) as count, SUM(valor) as total")
          .where(data: start_date..end_date).where(pago: :true)
          .group("1")
          .order("1")
          
        @categories = services_data.map { |s| I18n.l(s.month, format: '%B') }
        @services_data = services_data.map { |s| s.count }
        @profit_data = services_data.map { |s| s.total }
   
    end
end
