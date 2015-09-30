# Creating Your Object Model

# We want two classes: Post and Comment. A post has many comments and each comment belongs 
# to exactly one post. Let's build the Post class so it has the following attributes: 
# title, url, points, and item_id, corresponding to the title on Hacker News, the post's 
# URL, the number of points the post currently has, and the post's Hacker News item ID, 
# respectively.

# Additionally, create two instance methods:

# Post#comments returns all the comments associated with a particular post
# Post#add_comment takes a Comment object as its input and adds it to the comment list.
# You'll have to design the Comment object yourself. What attributes and methods should it support and why?

# We could go deeper and add, e.g., a User model, but we'll stop with Post and Comment.

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