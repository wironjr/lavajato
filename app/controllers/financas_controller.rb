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
    @despeses_mes = @despesas.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where.not(tipo: "VALE").sum(:valor)
    @servicos_lucro = @servicos_total - @despeses_mes
    @servicos_quantidade_mes = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month).count
    @servicos_pago_pendedente = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(pago: :false).count
    @servicos_mensal = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month)
    @despesas_mensal = @despesas.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where.not(tipo: "VALE")
    @despesas_valor = @despesas_mensal.where.not(tipo: "VALE").sum(:valor)
    
    @despesas_produtos_mes = @despesas.where(tipo: "PRODUTOS").where(data: Time.now.beginning_of_month..Time.now.end_of_month).sum(:valor)
    @despesas_geral_mes = @despesas.where.not(tipo: ["PRODUTOS","VALE"]).where(data: Time.now.beginning_of_month..Time.now.end_of_month).sum(:valor)
    
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
    @users = User.where.not(tipo: ["FUNCIONÁRIO", "FUNCIONÁRIO COM ACESSO"])
    mes = Time.now.month
    @users_func = User.where(tipo: ["FUNCIONÁRIO", "FUNCIONÁRIO COM ACESSO"]).where("extract(month from created_at) <= ?", mes)
    @despesas = Despesa.all
    @servicos = Servico.all

    ##### qnt de usuarios #####
    @users_quantidade = @users.count

    ##### lucro ######
    @servicos_total = @servicos.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(pago: :true).map(&:valor).sum
    @despeses_mes = @despesas.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where.not(tipo: "VALE").sum(:valor)
    @servicos_lucro = @servicos_total - @despeses_mes
    @servicos_lucro_individual =  @servicos_lucro / @users_quantidade

    @users.each do |usuario|
      recebido_usuario = Servico.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(caixa: usuario.nome.upcase).sum(:valor) + @despesas.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(tipo: "VALE").where(vale: usuario.nome.upcase).sum(:valor)
      falta_receber = @servicos_lucro_individual - recebido_usuario
      detalhe_recebido_despesa = @despesas.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(tipo: "VALE").where(vale: usuario.nome.upcase)
      detalhe_recebido_servico = Servico.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(caixa: usuario.nome.upcase)

      instance_variable_set("@recebido_#{usuario.nome}", recebido_usuario)
      instance_variable_set("@falta_receber_#{usuario.nome}", falta_receber)
      instance_variable_set("@detalhe_recebido_despesa_#{usuario.nome}", detalhe_recebido_despesa)
      instance_variable_set("@detalhe_recebido_servico_#{usuario.nome}", detalhe_recebido_servico)
    end
    
    @users_func.each do |user_func|
      recebido_caixa_func = Servico.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(caixa: user_func.nome.upcase).sum(:valor) + @despesas.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(tipo: "VALE").where(vale: user_func.nome.upcase).sum(:valor)
      salario_func = @despesas.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(tipo: "FUNCIONÁRIO").where(funcionario: user_func.nome.upcase).sum(:valor)
      falta_receber_func = salario_func - recebido_caixa_func

      instance_variable_set("@recebido_caixa_func_#{user_func.nome}", recebido_caixa_func)
      instance_variable_set("@salario_func_#{user_func.nome}", salario_func)
      instance_variable_set("@falta_receber_func_#{user_func.nome}", falta_receber_func)
    end
    
    if params[:mes_select]
      @mes = params[:mes_select]
      ano = @mes.split("-")[0].to_i
      mes = @mes.split("-")[1].to_i

      @users = User.where.not(tipo: ["FUNCIONÁRIO", "FUNCIONÁRIO COM ACESSO"]).where("extract(year from created_at) < ? OR (extract(year from created_at) = ? AND extract(month from created_at) <= ?)", ano, ano, mes)
      @users_func = User.where(tipo: ["FUNCIONÁRIO", "FUNCIONÁRIO COM ACESSO"]).where("extract(year from created_at) < ? OR (extract(year from created_at) = ? AND extract(month from created_at) <= ?)", ano, ano, mes)

      ##### qnt de usuarios #####
      @users_quantidade = @users.count

      ##### lucro ######
      @servicos_total = @servicos.where("DATE_PART('month', data) = ?", mes).where(pago: :true).map(&:valor).sum
      @despeses_mes = @despesas.where("DATE_PART('month', data) = ?", mes).where.not(tipo: "VALE").sum(:valor)
      @servicos_lucro = @servicos_total - @despeses_mes
      @servicos_lucro_individual =  @servicos_lucro / @users_quantidade

      @users.each do |usuario|
        recebido_usuario = Servico.where("DATE_PART('month', data) = ?", mes).where(caixa: usuario.nome.upcase).sum(:valor) + @despesas.where("DATE_PART('month', data) = ?", mes).where(tipo: "VALE").where(vale: usuario.nome.upcase).sum(:valor)
        falta_receber = @servicos_lucro_individual - recebido_usuario
        detalhe_recebido_despesa = @despesas.where("DATE_PART('month', data) = ?", mes).where(tipo: "VALE").where(vale: usuario.nome.upcase)
        detalhe_recebido_servico = Servico.where("DATE_PART('month', data) = ?", mes).where(caixa: usuario.nome.upcase)
  
        instance_variable_set("@recebido_#{usuario.nome}", recebido_usuario)
        instance_variable_set("@falta_receber_#{usuario.nome}", falta_receber)
        instance_variable_set("@detalhe_recebido_despesa_#{usuario.nome}", detalhe_recebido_despesa)
        instance_variable_set("@detalhe_recebido_servico_#{usuario.nome}", detalhe_recebido_servico)
      end
      
      @users_func.each do |user_func|
        recebido_caixa_func = Servico.where("DATE_PART('month', data) = ?", mes).where(caixa: user_func.nome.upcase).sum(:valor) + @despesas.where("DATE_PART('month', data) = ?", mes).where(tipo: "VALE").where(vale: user_func.nome.upcase).sum(:valor)
        salario_func = @despesas.where("DATE_PART('month', data) = ?", mes).where(tipo: "FUNCIONÁRIO").where(funcionario: user_func.nome.upcase).sum(:valor)
        falta_receber_func = salario_func - recebido_caixa_func
  
        instance_variable_set("@recebido_caixa_func_#{user_func.nome}", recebido_caixa_func)
        instance_variable_set("@salario_func_#{user_func.nome}", salario_func)
        instance_variable_set("@falta_receber_func_#{user_func.nome}", falta_receber_func)
      end
    end
    
  end


end
