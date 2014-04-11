class RecommendationsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:show, :index]
  # load_and_authorize_resource :except => [:show, :index]
  # skip_load_resource :only => [:create]

  before_action :set_recommendation, only: [:show, :edit, :update, :destroy]

  # GET /recommendations
  # GET /recommendations.json
  def index
    @recommendations = User.find(params[:user_id]).recommendations
  end

  # GET /recommendations/1
  # GET /recommendations/1.json
  def show
    @comments = @recommendation.comments
    @recommendation.stock_quote = StockQuote::Stock.quote(@recommendation.symbol)

    # TODO: should move to some cron job manager
    if not @recommendation.is_finalize
      # evaluate result
      start_date = @recommendation.created_at.to_date + 1.days

      end_date = @recommendation.end_at.to_date
      end_date = Date.yesterday if end_date > Date.yesterday

      stock_history = StockQuote::Stock.history(@recommendation.symbol, start_date, end_date)
      if stock_history.success?
        # stock_history will be <StockQuote>, if there is only one data return
        # create Array [<StockQuote>] 
        stock_history = [stock_history] unless stock_history.instance_of? Array

        for stock_quote in stock_history.reverse do
          high_price_diff = ((stock_quote.high / @recommendation.price) - 1.0) * 100.0
          low_price_diff = ((stock_quote.low / @recommendation.price) - 1.0) * 100.0

          new_result = { :action => :hold, :date => stock_quote.date }
          if @recommendation.term == :week
            p high_price_diff, low_price_diff
            if high_price_diff > 5
              new_result[:action] = :buy
              new_result[:price] = stock_quote.high
            elsif low_price_diff < -5
              new_result[:action] = :sell
              new_result[:price] = stock_quote.low
            end
          elsif @recommendation.term == :month
            if high_price_diff > 10
              new_result[:action] = :buy 
              new_result[:price] = stock_quote.high
            elsif low_price_diff < -10
              new_result[:action] = :sell
              new_result[:price] = stock_quote.low
            end
          else  # :quarter
            if high_price_diff > 20
              new_result[:action] = :buy
              new_result[:price] = stock_quote.high
            elsif low_price_diff < -20
              new_result[:action] = :sell
              new_result[:price] = stock_quote.low
            end
          end
          # ex: new_result = {:action=>:sell, :date=>"2014-02-18", :price=>9.24}

          old_result = @recommendation.result

          # p old_result, new_result

          if old_result.blank?  # never success
            if new_result[:action] == :hold
              # do nothing
            elsif ((@recommendation.action == :buy and new_result[:action] == :buy) or (@recommendation.action == :sell and new_result[:action] == :sell))
              # SUCCESS, so far
              @recommendation.result = new_result
            else
              # FAIL, wrong derection
              @recommendation.result = new_result
              @recommendation.is_finalize = true
            end
          else  # has been success
            if old_result[:action] != new_result[:action]
              @recommendation.is_finalize = true
            elsif ((new_result[:action] == :buy and new_result[:price] > old_result[:price]) or (new_result[:action] == :sell and new_result[:price] < old_result[:price]))
              @recommendation.result = new_result
            end

          end

          @recommendation.save
          break if @recommendation.is_finalize
        end  # end for stock_quote in stock_history.reverse do

        if Date.today > @recommendation.end_at.to_date
          if @recommendation.result.blank?  # action is :hold and price holds to the end
            @recommendation.result = { :action => :hold, :date => @recommendation.end_at.to_date }
          end
          @recommendation.is_finalize = true
          @recommendation.save
        end
      end  # end if stock_history.success?
    end  # end if not @recommendation.is_finalize


  end

  # GET /recommendations/new
  def new
    @recommendation = Recommendation.new
  end

  # GET /recommendations/1/edit
  # def edit
  # end

  # POST /recommendations
  # POST /recommendations.json
  def create
    # @recommendation = Recommendation.new(recommendation_params)
    @recommendation = current_user.recommendations.build(recommendation_params)
    stock_quote = StockQuote::Stock.quote(@recommendation.symbol)
    @recommendation.price = stock_quote.last_trade_price_only if stock_quote.success?

    respond_to do |format|
      if stock_quote.success? and @recommendation.save
        format.html { redirect_to @recommendation, notice: 'Recommendation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @recommendation }
      else
        flash[:error] = 'No such ticker symbol.' if stock_quote.no_data_message
        format.html { render action: 'new' }
        format.json { render json: @recommendation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recommendations/1
  # PATCH/PUT /recommendations/1.json
  # def update
  #   respond_to do |format|
  #     if @recommendation.update(recommendation_params)
  #       format.html { redirect_to @recommendation, notice: 'Recommendation was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @recommendation.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /recommendations/1
  # DELETE /recommendations/1.json
  # def destroy
  #   @recommendation.destroy
  #   respond_to do |format|
  #     format.html { redirect_to recommendations_url }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recommendation
      @recommendation = Recommendation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recommendation_params
      # params[:recommendation]
      params.require(:recommendation).permit(:symbol, :action, :term, :note)
    end
end
