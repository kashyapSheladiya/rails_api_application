class Api::V1::BooksController < ApplicationController
  before_action :load_book, only: :show
  def index
    @books = Book.all
    books_serializer = parse_json(@books)
    json_response "All Books", true, {books: books_serializer}, :ok
  end

  def show
    book_serializer = parse_json(@book)
    json_response "Book found successfully", true, {book: book_serializer}, :ok
  end

  private

  def load_book
    @book = Book.find_by id: params[:id]
    unless @book.present?
      json_response "Book not found", false, {}, :not_found
    end
  end
end