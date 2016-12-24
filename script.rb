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
end

class ElasticsearchClient < HTTPClient

  def search(query)
    get("/_search?q=#{query}*")
  end

  def create(index, type, id, data)
    put("/#{index}/#{type}/#{id}", data.to_json)
  end

end

## Sample
client = ElasticsearchClient.new

index = 'article'
type = 'image'

# 10.times do |i|
#   client.create(index, type, i, { data: "a1#{i}b" })
# end

result = client.search("a")
puts "------"
p JSON.parse(result.body)
