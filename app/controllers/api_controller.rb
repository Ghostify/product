class ApiController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  def elastic_create
    # anti_bot = params["pass"]
    #
    # if anti_bot.eql? "noentry"
    if body = JSON.parse(request.body.read)
      if res = post_json("http://localhost:9200/ghost/videos/", body)
        render :json => JSON.parse(res)
      else
        render :json => "Error"
      end
    else
      render :json => "Cannot parse request.body.read"
    end
    # else
    #   render :json => "Password incorrect." + params.inspect
    # end
  end

  def elastic_get
    render :json => get_json("http://localhost:9200/ghost/videos/_search/")
  end

  def elastic_search
    search = params["q"]
    if search
      render :json => get_search("http://localhost:9200/ghost/videos/_search?size=2000&pretty=1", search)
    else
      render :json => "Missing search!"
    end
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
    return HTTParty.get(url)
  end

  def get_search(url, q)
    query = hash_tree
    # query["query"]["wildcard"]["transcript"] = "#{q}*"
    # query["query"]["match"]["Hello"] = "#{q}*"
    # puts "JSON:: #{query.to_json}"
    query = (url + "&q=" + q)
    puts query
    return HTTParty.get(query)
  end

  def hash_tree
    Hash.new do |hash, key|
      hash[key] = hash_tree
    end
  end
end
