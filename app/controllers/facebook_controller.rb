class FacebookController < ApplicationController
  def channel
    cache_period = 365.days
    expires_in cache_period, :public => true
    response.headers["Expires"] = CGI.rfc1123_date(Time.now + cache_period)
  end
end