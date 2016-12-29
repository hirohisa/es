require 'elasticsearch'



@client = Elasticsearch::Client.new

index = 'article'
type = 'image'

def delete_data(index, type, list)
  list.each do |i|
    @client.remove(index, type, i)
  end
end

def create_data(index, type)
  data = { title: "onepeace", tags: 'action fantasy jump' }
  @client.create(index, type, 1, data)

  data = { title: "naruto", tags: 'action ninja jump' }
  @client.create(index, type, 2, data)

  data = { title: "magi", tags: 'action fantasy sunday' }
  @client.create(index, type, 3, data)

  data = { title: "hit", tags: 'game ios' }
  @client.create(index, type, 4, data)

  data = { title: "dragon ball", tags: 'toriyama action jump' }
  @client.create(index, type, 5, data)

  data = { title: "dragon quest", tags: 'game toriyama game' }
  @client.create(index, type, 6, data)

  data = { title: "FF", tags: 'game fantasy' }
  @client.create(index, type, 7, data)
end

# delete_data(index, type, [1..7])
# create_data(index, type)

result = @client.search index: 'tags', body: {
  query: {
    match: {
      message: 'myProduct'
    }
  },
  aggregations: {
    top_10_states: {
      terms: {
        field: 'state',
        size: 10
      }
    }
  }
}
#result = @client.search("")
puts "------"
p JSON.parse(result.body)
