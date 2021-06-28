require 'open-uri'
require 'nokogiri'
require 'csv'
require 'json'
require_relative 'http_reqs'

url = 'https://play.google.com/store/books/collection/cluster?clp=sgIqCiIKHHByb21vdGlvbl9lYm9va19mcmVlX3ByZXZpZXcQRBgBIgQIBQgs:S:ANO1ljKncLs&gsr=Ci2yAioKIgoccHJvbW90aW9uX2Vib29rX2ZyZWVfcHJldmlldxBEGAEiBAgFCCw%3D:S:ANO1ljLHWg0'
url2 = 'https://play.google.com/store/books/collection/cluster?clp=8gMiCiAKGnByb21vdGlvbl9lYm9va190b3BzZWxsaW5nEEQYAQ%3D%3D:S:ANO1ljKR2RI&gsr=CiXyAyIKIAoacHJvbW90aW9uX2Vib29rX3RvcHNlbGxpbmcQRBgB:S:ANO1ljJtcVM'
def scraper(url)
  doc = Nokogiri::HTML(URI.open(url))
  books = []
  count = 0
  doc.search(".b8cIId.ReQCgd a").each do |element|
    book_path = 'https://play.google.com' + element.attributes['href'].value
    book_doc = Nokogiri::HTML(URI.open(book_path), nil, Encoding::UTF_8.to_s)

    if !(book_doc.search(".sIskre .AHFaub span").text).empty?
      title = book_doc.search('.sIskre .AHFaub span').text
      author = book_doc.search("span.ExjzWd a.hrTbp.R8zArc").text
      image = book_doc.search('div.hkhL9e img.T75of')[0].attributes['src'].value
      description = book_doc.search('div.W4P4ne meta')[0].attributes['content'].value.to_s
      url = book_path
      price = book_doc.search('span.oocvOe button.LkLjZd.ScJHi.HPiPcc.IfEcue').text[1..5].to_f

      books << { :title => title, :author => author, :description => description, :url => url, :img_url => image, :price => price } if !title.nil?
      count += 1
      break if count == 10
    end
  end

  http_req = Req.new

  books.each do |book|
    p http_req.posts(book)
  end
end


scraper(url2)