class Finance::StopsController < FinanceController
  include Messages

  before_action :authenticate_user!, except: [:analyze]
  # CanCan does not currently support StrongParameters
  authorize_resource only: [:create]
  load_and_authorize_resource except: [:analyze, :create]

  def create
    # Create the new stop model from params
    @stop = Stop.new(stop_params)
    @stop.symbol.try(:upcase!)
    @stop.user = current_user
    attempt_create!(@stop, finance_portfolios_path, new_finance_stop_path)
  end

  def destroy
    attempt_destroy!(@stop, finance_stops_path)
  end

  def edit
  end

  def index
    @stops.order!(:symbol)
  end

  def new
    @stop = Stop.new
    @stop.symbol = params[:symbol]
  end

  def show
  end

  def update
    if @stop.update_stop_price?(params[:stop])
      attempt_update!(@stop, finance_portfolios_path, edit_finance_stop_path(@stop.id))
    else
      redirect_to edit_finance_stop_path(@stop.id), notice: 'No update necessary'
    end
  end

  private

  def stop_params
    params.require(:stop).permit(
      :percentage,
      :quantity,
      :stop_price,
      :symbol
    )
  end
end

