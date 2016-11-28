class MwsClient

  def initialize (merchant_id, auth_token)
    @merchant_id = merchant_id
    @auth_token = auth_token
  end

  def get_clean_orders(created_after, created_before)
    @client = MWS.orders(
      primary_marketplace_id: ENV['PRIMARY_MARKETPLACE_ID'],
      merchant_id: @merchant_id,
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      auth_token: @auth_token
    )

    @created_after = created_after
    @created_before = created_before

    response = @client.list_orders created_after: @created_after, created_before: @created_before

    @clean_orders_hash = response.parse

    clean_orders = @clean_orders_hash["Orders"]["Order"]

    if next_token?(@clean_orders_hash) == true
      process_next_request
    else
      return clean_orders
    end

  end

  def next_token?(hash)
    @hash = hash
    @hash["NextToken"] != nil
  end

  def get_next_token(hash)
    @hash = hash
    @hash["NextToken"]
  end

  def get_hash
    @batch_count > 1 ? eval('@response' + @batch_count.to_s) : @clean_orders_hash
  end

  def process_next_request
    @batch_count = 1
    @all_hashes = [@clean_orders_hash["Orders"]["Order"]]
    while next_token?(get_hash) == true do
      response = @client.list_orders_by_next_token(get_next_token(get_hash))
      @batch_count += 1
      instance_variable_set('@response' + @batch_count.to_s, response.parse)
      @all_hashes.push(eval('@response' + @batch_count.to_s)["Orders"]["Order"])
    end
    combine_order_hashes
  end

  def combine_order_hashes
    @final_hash = [*@all_hashes.map(&:to_a).flatten]
  end

end
