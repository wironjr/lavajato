class StaticPagesController < ApplicationController
    before_action :require_logged_in_user
    def index
        @nome = "Wiron"
        @servicos = Servico.all
        @servicos_total = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(pago: :true).map(&:valor).sum
        @servicos_quantidade_mes = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month).count
        @servicos_pago_pendedente = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(pago: :false).count
        
        @servicos_graf = Servico.select("date_trunc('month', data) as mes, count(*) as quantidade, sum(valor) as lucro").where("data >= ?", 3.months.ago).group("date_trunc('month', data)")
        @meses_em_portugues = {"January" => "Janeiro", "February" => "Fevereiro", "March" => "Março", "April" => "Abril", "May" => "Maio", "June" => "Junho", "July" => "Julho", "August" => "Agosto", "September" => "Setembro", "October" => "Outubro", "November" => "Novembro", "December" => "Dezembro"}
        @dados_grafico = @servicos_graf.map {|s| [@meses_em_portugues[s.mes.strftime("%B")], s.quantidade, s.lucro]}.last(3)

    end
end
