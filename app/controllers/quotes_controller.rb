class QuotesController < ApplicationController
  before_action :set_quote, only: %i[edit]

  def index
    @quotes = Quote.all
  end

  def new
    @quote = Quote.new
  end

  def edit
  end

  private

  def set_quote
    @quote = Quote.find(params[:id])
  end

  def quote_params
    params.require(:quote).permit(:name)
  end
end
