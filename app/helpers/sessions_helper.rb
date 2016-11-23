module SessionsHelper

  def mws_auth_token
    session[:auth_hash]["credentials"]["token"]
  end

  def current_merchant_id
    session[:merchant_id]
  end

  # def check_aws_login?
  #   if session[:auth_login] == nil
  #     false
  #   else true
  #   end
  # end

end
