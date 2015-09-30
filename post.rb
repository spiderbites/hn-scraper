require 'set'

class Post

  attr_reader :title, :url, :points, :item_id

  def initialize(title, url, points, item_id)
    @title = title
    @url = url
    @points = points
    @item_id = item_id
    @comments = []
  end

  def to_s
    puts "#{@title}, #{@url}, #{@points}, #{@item_id}"
  end

  # returns all the comments associated with a particular post
  def comments
    @comments
  end

  # takes a Comment object as its input and adds it to the comment list.
  def add_comment(comment)
    @comments << comment
  end

  def unique_commenters
    Set.new(@comments.map {|comment| comment.user})
  end

  def average_comment_wordcount

    (@comments.map {|c| c.comment_wordcount}.reduce(:+)) / @comments.length.to_f
  end

end