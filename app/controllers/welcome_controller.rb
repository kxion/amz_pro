require 'peddler'
require 'json'
require 'money'

class WelcomeController < ApplicationController

  def index
    @mws_client = MwsClient.new(current_merchant_id, mws_auth_token)

    get_start_date
    get_end_date

    @clean_orders = @mws_client.get_clean_orders(@created_after_date, @created_before_date)
    format_order_count
    format_order_sum
    sales_total
    sum_aggregator(@agr_date_sum_hash, 'month')
    count_aggregator(@agr_date_count_hash, 'month')
  end

  def show
  end

  private

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

    def sum_aggregator(set, period)
      @set = set
      @period = period

      period_map = {
        'week' => 'at_beginning_of_week',
        'month' => 'at_beginning_of_month',
        'quarter' => 'at_beginning_of_quarter',
        'year' => 'at_beginning_of_year'
      }
      @period_function = period_map[@period]

      @agr_period_sum_hash = {}
      @set.each { |order_date, amount|
        aggregated_date = Date.parse(order_date).send(@period_function)
        if @agr_period_sum_hash.key?(aggregated_date) == false && amount != nil
          @agr_period_sum_hash[aggregated_date] = amount
        elsif amount != nil
          @agr_period_sum_hash[aggregated_date] += amount
        end
      }
    end

    def count_aggregator(set, period)
      @set = set
      @period = period

      period_map = {
        'week' => 'at_beginning_of_week',
        'month' => 'at_beginning_of_month',
        'quarter' => 'at_beginning_of_quarter',
        'year' => 'at_beginning_of_year'
      }
      @period_function = period_map[@period]

      @agr_period_count_hash = {}
      @set.each { |order_date, amount|
        aggregated_date = Date.parse(order_date).send(@period_function)
        if @agr_period_count_hash.key?(aggregated_date) == false && amount != nil
          @agr_period_count_hash[aggregated_date] = amount
        elsif amount != nil
          @agr_period_count_hash[aggregated_date] += amount
        end
      }
    end

    def get_start_date
      if params.has_key?(:q)
        @created_after_date = params[:q]
      else
        @created_after_date = Date.today.at_beginning_of_month
      end
    end

    def get_end_date
      if params.has_key?(:qq)
        @created_before_date = params[:qq]
      else
        @created_before_date = Date.today
      end
    end

end
