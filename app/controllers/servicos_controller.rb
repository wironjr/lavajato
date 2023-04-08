class ServicosController < ApplicationController
  before_action :require_logged_in_user
  before_action :set_servico, only: %i[ show edit update destroy ]
  include Pagy::Backend

  # GET /servicos or /servicos.json
  def index
    @servicos = Servico.all.order(:data)
    @servicos_do_dia = @servicos.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'")
    @servicos_total = @servicos.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'").where(pago: :true).map(&:valor).sum
    @servicos_quantidade_diario = @servicos.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'").count
    @servicos_pago_pendedente = @servicos.where("to_char(data,'YYYY-MM-DD') = '#{Time.now.to_date.to_s}'").where(pago: :false).count
    @users = User.all.select("id","nome").order(:nome)

    @pagy, @servicos = pagy(@servicos)
  end

  def todos
    @servicos = Servico.all.order(:data)
    @servicos_total = @servicos.map(&:valor).sum
    @servicos_quantidade = @servicos.count
    @servicos_pago_pendedente = @servicos.where(pago: :false).count

    if params[:data_search] || params[:cliente_busca]
      @servicos = @servicos.where('cliente ILIKE ?', "%#{params[:cliente_busca]}%") if params[:cliente_busca].present?
      @servicos_pago_pendedente = @servicos.where(pago: :false).count
      if params[:data_search].present?
        params[:data_search] = Date.parse(params[:data_search]).strftime("%Y-%m-%d")
        @servicos = @servicos.where('CAST(data AS TEXT) LIKE ?', "%#{params[:data_search]}%")
        @servicos_total = @servicos.map(&:valor).sum
        @servicos_quantidade = @servicos.count
        @servicos_pago_pendedente = @servicos.where(pago: :false).count
      end
    end

    @pagy, @servicos = pagy(@servicos)
  end

  def mensal
    @servicos_all = Servico.all.order(:data)
    @servicos = @servicos_all.where(data: Time.now.beginning_of_month..Time.now.end_of_month)
    @servicos_total = @servicos_all.where(data: Time.now.beginning_of_month..Time.now.end_of_month).where(pago: :true).map(&:valor).sum
    @servicos_pago_pendedente = @servicos.where(pago: :false).count

    
    if params[:mes_select] || params[:cliente_busca]
      @mes = params[:mes_select] || Time.now.month
      @servicos = @servicos_all.where("DATE_PART('month', data) = ?", @mes) if params[:mes_select].present?
      @servicos = @servicos_all.where('cliente ILIKE ?', "%#{params[:cliente_busca]}%") if params[:cliente_busca].present?
      @servicos_pago_pendedente = @servicos.where(pago: :false).count

      @servicos_total = @servicos_all.where("DATE_PART('month', data) = ?", @mes).where(pago: :true).map(&:valor).sum
      @servicos_quantidade_mes = @servicos_all.where("DATE_PART('month', data) = ?", @mes).count
    else
      @servicos = @servicos_all.where(data: Time.now.beginning_of_month..Time.now.end_of_month)
      @servicos_quantidade_mes = @servicos_all.where(data: Time.now.beginning_of_month..Time.now.end_of_month).count
      @servicos_pago_pendedente = @servicos.where(pago: :false).count
    end

    @pagy, @servicos = pagy(@servicos)
  end

  # GET /servicos/1 or /servicos/1.json
  def show
  end

  # GET /servicos/new
  def new
    @servico = Servico.new
    @users = User.all.select("id","nome").order(:nome)
  end

  # GET /servicos/1/edit
  def edit
    @users = User.all.select("id","nome").order(:nome)
  end

  # POST /servicos or /servicos.json
  def create
    @users = User.all.select("id","nome").order(:nome)
    params[:servico][:valor] = params[:servico][:valor].gsub('R$','').gsub(' ','').gsub('.','')

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
    @users = User.all.select("id","nome").order(:nome)
    params[:servico][:valor] = params[:servico][:valor].gsub('R$','').gsub(' ','').gsub('.','')
   
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
      params.require(:servico).permit(:cliente, :data, :servico, :valor, :caixa, :pago, :veiculo)
    end
end
