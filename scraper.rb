require 'open-uri'
require 'nokogiri'
require 'csv'
require 'json'

url = 'https://play.google.com/store/books/collection/cluster?clp=sgIqCiIKHHByb21vdGlvbl9lYm9va19mcmVlX3ByZXZpZXcQRBgBIgQIBQgs:S:ANO1ljKncLs&gsr=Ci2yAioKIgoccHJvbW90aW9uX2Vib29rX2ZyZWVfcHJldmlldxBEGAEiBAgFCCw%3D:S:ANO1ljLHWg0'
def scraper(url)
  doc = Nokogiri::HTML(URI.open(url))
  books = []
  count = 0

  doc.search(".b8cIId.ReQCgd a").each do |element|
    book_path = 'https://play.google.com' + element.attributes['href'].value
    book_doc = Nokogiri::HTML(URI.open(book_path), nil, Encoding::UTF_8.to_s)

    if !(book_doc.search(".sIskre .AHFaub span").text).empty?
      name = book_doc.search(".sIskre .AHFaub span").text
      author = book_doc.search("span.ExjzWd a.hrTbp.R8zArc").text
      image = book_doc.search('div.hkhL9e img.T75of')[0].attributes['src'].value
      description = book_doc.search('div.W4P4ne meta')[0].attributes['content'].value.to_s
      link = book_path

      books << { :name => name, :author => author, :image => image, :description => description, :link => link } if !name.nil?
      count += 1
    end
  end

  File.write('./books.json', JSON.dump(JSON.parse(books.to_json)))

end

scraper(url)
