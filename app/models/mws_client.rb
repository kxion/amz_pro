class MwsClient

  def initialize (merchant_id, auth_token)
    @merchant_id = merchant_id
    @auth_token = auth_token
  end

  def get_clean_orders
    client = MWS.orders(
      primary_marketplace_id: "",
      merchant_id: @merchant_id,
      aws_access_key_id: "",
      aws_secret_access_key: "",
      auth_token: @auth_token
    )

    response = client.list_orders created_after: '2016-10-25'
    clean_orders_hash = response.parse
    clean_orders = clean_orders_hash["Orders"]["Order"]
  end

end
