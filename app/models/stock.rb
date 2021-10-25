class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, presence: true
  validates :ticker, presence: true, uniqueness: true

  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:publishable_token],
      secret_token:      Rails.application.credentials.iex_client[:secret_token],
      endpoint:          Rails.application.credentials.iex_client[:endpoint]
    )
    begin
      new(ticker: ticker_symbol.upcase, name: client.company(ticker_symbol).company_name,
          last_price: client.price(ticker_symbol))
    rescue StandardError => e
      nil
    end
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end
end
