module SessionsHelper

  def mws_auth_token
    session[:auth_hash]["credentials"]["token"]
  end

  def current_merchant_id
    session[:merchant_id]
  end


  def complete_login?
    mws_login? == true && local_login? == true ? true : false
  end

    def mws_login?
      session[:auth_hash] != nil ? true : false
    end

    def local_login?
      session[:merchant_id] != nil ? true : false
    end

end
