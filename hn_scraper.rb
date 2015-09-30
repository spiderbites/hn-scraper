require 'open-uri'
require 'nokogiri'
require_relative 'post'
require_relative 'comment'


class MissingArgumentError < StandardError; end

class HackerNewsScraper
  def initialize(url)
    if url.nil?
      raise MissingArgumentError
    end
    html_file = open(url)
    file = File.open(html_file)
    @doc = Nokogiri::HTML(file)
  end

  def parse
    @post = scrape_post
    scrape_comments.each { |comment| @post.add_comment(comment) }
  end

  def stat_print
    puts "Post title: #{@post.title}\n" +
        "Post url: #{@post.url}\n" +
        "Post points: #{@post.points}\n" +
        "Number of comments: #{@post.comments.length}\n" +
        "Number of unique commenters: #{@post.unique_commenters.length}\n" +
        "Average comment wordcount: #{@post.average_comment_wordcount}"
  end

  private

  # POSTS

  def scrape_post
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

  # COMMENTS

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

  def scrape_comments
    comments_username.zip(comments_id, comments_date, comments_text).map do |comment_arr|
      Comment.new(*comment_arr)
    end
  end
end


# PROGRAM RUNS FROM HERE

begin
  hns = HackerNewsScraper.new(ARGV[0])
  hns.parse
  hns.stat_print
rescue MissingArgumentError # user supplied no file/URL
  puts "Usage: ruby hn_scraper.rb URL"
rescue Errno::ENOENT => e  # user suppplied file that does not exist
  puts "Error: " + e.message
rescue TypeError => e # some error related to asking for a bad URL
  puts "Error: " + e.message
rescue SocketError => e # some error related to asking for a bad URL
  puts "Error: " + e.message
end
