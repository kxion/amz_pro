require "peddler"
require 'json'

class WelcomeController < ApplicationController

  def index
    client = MWS.orders(
      primary_marketplace_id: "",
      merchant_id: "",
      aws_access_key_id: "",
      aws_secret_access_key: "",
    )

    response = client.list_orders created_after: '2016-10-25'
    clean_orders_hash = response.parse
    @clean_orders = clean_orders_hash["Orders"]["Order"]


    date_count_hash = {}
    @clean_orders.each { |order|
      date_count_hash[order["PurchaseDate"]] = 1
    }

    @agr_date_count_hash = {}
    date_count_hash.each { |order_date, date_count|
      date_no_time = order_date[0..9]
      if @agr_date_count_hash.key?(date_no_time) == false
        @agr_date_count_hash[date_no_time] = 1
      else
        @agr_date_count_hash[date_no_time] += 1
      end
    }

  end

end
