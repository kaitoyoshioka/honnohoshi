# frozen_string_literal: true

class Amazon
  include Serviceable

  attr_reader :average_rating, :review_count, :url

  def search(isbn)
    @book = RakutenRapidAPI::AmazonPrice.search(isbn).first

    if book_exists?
      @url = @book["detailPageURL"]
      @average_rating = @book["rating"]
      @review_count = @book["totalReviews"]
    end
  end

  def book_exists?
    !@book.nil?
  end

  def name
    "Amazon"
  end
end
