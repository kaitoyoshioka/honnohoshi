# frozen_string_literal: true

require "test_helper"

module OpenBD
  class BooksearcherTest < ActiveSupport::TestCase
    setup do
      stub_open_bd
    end

    test ".search" do
      book = OpenBD::BookSearcher.search("9784101010014")

      assert_equal("https://cover.openbd.jp/9784101010014.jpg", book.cover_image)
      assert_equal("新潮社", book.publisher)
      assert_equal("2003-06", book.release_date)
      assert_equal("吾輩は猫である", book.title)
      assert_equal("夏目漱石／著", book.author)
      assert_equal("9784101010014", book.isbn13)
    end
  end
end
