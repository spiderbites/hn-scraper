class Comment

  attr_reader :user, :item_id, :date, :text

  def initialize(user, item_id, date, text)
    @user = user
    @item_id = item_id
    @date = date
    @text = text
  end

  def comment_wordcount
    @text.split.length
  end

end