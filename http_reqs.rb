require 'rubygems'
require 'httparty'
require 'json'

class Req
  include HTTParty
  base_uri "http://localhost:3000"

  def get
    self.class.get('/books')
  end

  def posts(book)
    self.class.post('/books', body: {
      title: book[:title],
      author: book[:author],
      description: book[:description],
      img_url: book[:img_url],
      price: book[:price],
      url: book[:url]
    })
  end
end

# http_req = Interactions.new
#
# books = [
#   {
#     title: "book[:title]",
#     author: "book[:author]",
#     description: "book[:description]",
#     img_url: "book[:img_url]",
#     price: "book[:price]",
#     url: "book[:url]"
#   },
#   {
#     title: "book[:title]",
#     author: "book[:author]",
#     description: "book[:description]",
#     img_url: "book[:img_url]",
#     price: "book[:price]",
#     url: "book[:url]"
#   }
# ]
#
# books.each do |book|
#   http_req.posts(book)
# end