module SessionsHelper

  def aws_auth_token
    session[:auth_hash]
  end

  # def check_aws_login?
  #   if session[:auth_login] == nil
  #     false
  #   else true
  #   end
  # end

end
