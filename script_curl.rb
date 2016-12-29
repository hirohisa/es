require 'net/http'
require 'uri'
require 'json'

class HTTPClient

  attr_accessor :host, :port

  def initialize
    @host ||= "127.0.0.1"
    @port ||= 9200
  end

  def http
    Net::HTTP.new(@host, @port)
  end

  def get(request_uri, header = {})
    http.get(request_uri, header)
  end

  def post(request_uri, payload, header = {})
    http.post(request_uri, payload, header)
  end

  def put(request_uri, data, header = {})
    http.put(request_uri, data, header)
  end

  def delete(request_uri, header = {})
    http.delete(request_uri, header)
  end

end

class ElasticsearchClient < HTTPClient

  def search_tag(tag)
    get("/_search?q=tags:#{tag}")
  end

  def create(index, type, id, data)
    put("/#{index}/#{type}/#{id}", data.to_json)
  end

  def remove(index, type, id)
    delete("/#{index}/#{type}/#{id}")
  end

end

## Sample
@client = ElasticsearchClient.new
index = 'article'
type = 'image'

def delete_data(index, type, list)
  list.each do |i|
    @client.remove(index, type, i)
  end
end

def create_data(index, type)
  data = { title: "ワンピース", tags: ['action', 'fantasy', 'jump'] }
  @client.create(index, type, 1, data)

  data = { title: "ナルト", tags: ['action', 'ninja', 'jump'] }
  @client.create(index, type, 2, data)

  data = { title: "マギ", tags: ['action', 'fantasy', 'sunday'] }
  @client.create(index, type, 3, data)

  data = { title: "hit", tags: ['game', 'ios'] }
  @client.create(index, type, 4, data)

  data = { title: "ドラゴンボール", tags: ['toriyama', 'action', 'jump'] }
  @client.create(index, type, 5, data)

  data = { title: "ドラゴンクエスト", tags: ['game', 'toriyama', 'game'] }
  @client.create(index, type, 6, data)

  data = { title: "FF", tags: ['game', 'fantasy'] }
  @client.create(index, type, 7, data)
end

# delete_data(index, type, [1..7])
# create_data(index, type)

result = @client.search_tag("game")
#result = @client.search("")
puts "------"
p JSON.parse(result.body)
