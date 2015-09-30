# Loading Hacker News Into Objects

# We now need code which does the following:

# 1. Instantiates a Post object
# 2. Parses the Hacker News HTML
# 3. Creates a new Comment object for each comment in the HTML, adding it to the Post 
# object in (1)

# $ ruby hn_scraper.rb https://news.ycombinator.com/item?id=5003980
# Post title: XXXXXX
# Number of comments: XXXXX
# ... some other statistics we might be interested in -- your choice ...

require 'open-uri'
require 'nokogiri'
require 'date'
require_relative 'post'

class HackerNewsScraper

  def initialize(doc)
    @doc = doc
  end

  def post
    Post.new(post_title, post_url, post_points, post_item_id)
  end

  def post_title
    @doc.search('.title > a').map { |link| link.inner_text }[0]
  end

  def post_url
    @doc.search('.title > a').map { |link| link['href'] }[0]
  end

  def post_points
    @doc.search('.score').map { |span| span.inner_text }[0].to_i
  end

  def post_item_id
    @doc.search('.score')[0]["id"].gsub(/\D/,"").to_i
  end

  def comments_username
    @doc.search('.comhead > a:first-child').map do |element|
      element.inner_text
    end[1..-1] # first result is something we dont want
  end

  def comments_id
    @doc.search('.comhead > a:nth-child(2)').map do |link|
      link['href'].gsub(/\D/,"").to_i
    end
  end

  def comments_date
    @doc.search('.comhead > a:nth-child(2)').map do |element|
      Date.today - element.inner_text.to_i      
    end
  end

  def comments_text
    @doc.search('.comment > span').map do |span|
      span.inner_text.gsub(/\n.*$/,"")
    end
  end
end


html_file = open(ARGV[0])
hns = HackerNewsScraper.new(Nokogiri::HTML(File.open(html_file)))