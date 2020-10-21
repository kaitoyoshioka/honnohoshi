# frozen_string_literal: true

require "application_system_test_case"
require "webmock/minitest"

class SearchTest < ApplicationSystemTestCase
  setup do
    WebMock.allow_net_connect!(net_http_connect_on_start: true)
    stub_open_bd
  end

  test "search by ISBN-13 to view book information" do
    visit root_path

    fill_in "isbn", with: "9784101010014"
    find(".search__btn").click

    assert find("img[src='https://cover.openbd.jp/9784101010014.jpg']")
    assert_text("吾輩は猫である")
    assert_text("夏目漱石／著")
    assert_text("新潮社")
    assert_text("2003-06")
  end

  test "search by ISBN-13 including hyphen to view book information" do
    visit root_path

    fill_in "isbn", with: "978-4101010014"
    find(".search__btn").click

    assert find("img[src='https://cover.openbd.jp/9784101010014.jpg']")
    assert_text("吾輩は猫である")
    assert_text("夏目漱石／著")
    assert_text("新潮社")
    assert_text("2003-06")
  end

  test "search by ISBN-10 to view book information" do
    visit root_path

    fill_in "isbn", with: "4101010013"
    find(".search__btn").click

    assert find("img[src='https://cover.openbd.jp/9784101010014.jpg']")
    assert_text("吾輩は猫である")
    assert_text("夏目漱石／著")
    assert_text("新潮社")
    assert_text("2003-06")
  end

  test "search by invalid string to view error message" do
    visit root_path

    fill_in "isbn", with: "invalidstring"
    find(".search__btn").click

    assert_text("ISBN-13またはISBN-10を入力してください")
  end

  test "search by nonexistent ISBN to view error message" do
    visit root_path

    fill_in "isbn", with: "9784101010013"
    find(".search__btn").click

    assert_text("書籍が見つかりませんでした")
  end

  test "when visit search_path, don't view error message" do
    visit search_path

    assert_no_text("ISBN-13またはISBN-10を入力してください")
    assert_no_text("書籍が見つかりませんでした")
  end

  test "search by ISBN to view RakutenBooks rating" do
    stub_rakuten_books

    visit root_path

    fill_in "isbn", with: "978-4101010014"
    find(".search__btn").click

    assert page.all(".book-reviews__star-rating")[0]
    assert_equal("3.93", page.all(".book-reviews__average-rating")[0].text)
    assert_equal("(レビュー192件)", page.all(".book-reviews__review-count")[0].text)
    assert has_link?("楽天ブックス")
  end

  test "search by ISBN to view Bookmeter rating" do
    stub_bookmeter_search_results_by_isbn
    stub_bookmeter

    visit root_path

    fill_in "isbn", with: "978-4101010014"
    find(".search__btn").click

    assert page.all(".book-reviews__star-rating")[1]
    assert_equal("4.1", page.all(".book-reviews__average-rating")[1].text)
    assert_equal("(レビュー1094件)", page.all(".book-reviews__review-count")[1].text)
    assert has_link?("読書メーター")
  end

  test "search by ISBN to view Hongasuki rating" do
    stub_hongasuki_search_results_by_isbn
    stub_hongasuki

    visit root_path

    fill_in "isbn", with: "978-4101010014"
    find(".search__btn").click

    assert page.all(".book-reviews__star-rating")[2]
    assert_equal("4.11", page.all(".book-reviews__average-rating")[2].text)
    assert_equal("(レビュー10件)", page.all(".book-reviews__review-count")[2].text)
    assert has_link?("本が好き！")
  end
end
