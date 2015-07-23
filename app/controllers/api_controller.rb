class ApiController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  def elastic_create
    anti_bot = params["pass"]
    if anti_bot.eql? "noentry"
      if body = JSON.parse(request.body.read)
        render :json => post_json("http://localhost:9200/ghost/videos", body)
      else
        render :json => "Cannot parse request.body.read"
      end
    else
      render :json => "Password incorrect."
    end
  end

  def elastic_get
    render :json => get_json("http://localhost:9200/ghost/videos/_search")
  end

  private
  def post_json(url, content)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
    req.body = content.to_json
    res = http.request (req)
    return res.body
  end

  def get_json(url)
    return HTTParty.get(url).body
  end
end
