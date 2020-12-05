# frozen_string_literal: true

class RakutenBooksBookRating < BookRating
  attr_reader :average_rating, :review_count, :url

  def service_name
    "楽天ブックス"
  end

  def service_logo
    "rakutenbooks-logo.png"
  end

  def book_exists?
    !@book.nil?
  end

  def search(isbn)
    @book = RakutenWebService::Books::Book.search(isbn: isbn).first

    if book_exists?
      @url = @book.affiliate_url
      @average_rating = @book.review_average
      @review_count = @book.review_count
    end
  end
end
