require 'peddler'
require 'json'
require 'money'

class WelcomeController < ApplicationController

  def index

    mws_call

    format_order_count

    format_order_sum

    sales_total

  end

  private

    def mws_call
      client = MWS.orders(
        primary_marketplace_id: "",
        merchant_id: "",
        aws_access_key_id: "",
        aws_secret_access_key: "",
      )

      response = client.list_orders created_after: '2016-10-25'
      clean_orders_hash = response.parse
      @clean_orders = clean_orders_hash["Orders"]["Order"]
    end

    def format_order_count
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

    def format_order_sum
      date_sum_hash = {}
      @clean_orders.each { |order|
        date_sum_hash[order["PurchaseDate"]] = order.dig("OrderTotal", "Amount").to_f
      }

      @agr_date_sum_hash = {}
      date_sum_hash.each { |order_date, amount|
        date_no_time = order_date[0..9]
        if @agr_date_sum_hash.key?(date_no_time) == false && amount != nil
          @agr_date_sum_hash[date_no_time] = amount
        elsif amount != nil
          @agr_date_sum_hash[date_no_time] += amount
        end
      }
    end

    def sales_total
      @total = 0
      @agr_date_sum_hash.each { |order_date, amount|
        @total += amount
      }
      @total = Money.us_dollar(@total * 100).format
    end

end
