class Api::V1::ReviewsController < ApplicationController
  before_action :load_book, only: :index
  before_action :load_review, only: [:show, :update, :destroy]
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]

  def index
    @reviews = @book.reviews
    if @reviews.present?
      json_response "All reviews", true, {reviews: @reviews}, :ok
    else
      json_response "There are no reviews yet", true, {reviews: @reviews}, :ok
    end
  end

  def show
    json_response "Show review successfully", true, {reviews: @review}, :ok
  end

  def create
    review = Review.create(review_params)
    review.user_id = current_user.id
    review.book_id = params[:book_id]
    if review.save
      json_response "Review created successfully", true, {reviews: review}, :ok
    else
      json_response "Review creation failed", false, {}, :unprocessable_entity
    end
  end

  def update
    if correct_user @review.user
      if @review.update(review_params)
        json_response "Review updated successfully", true, {reviews: @review}, :ok
      else
        json_response "Review updation failed", false, {}, :unprocessable_entity
      end
    else
      json_response "Cannot update review", false, {}, :unauthorized
    end
  end

  def destroy
    if correct_user @review.user
      if @review.destroy
        json_response "Delete review successfully", true, {}, :ok
      else
        json_response "Delete review failed", false, {}, :unprocessable_entity
      end
    else
      json_response "Cannot delete review", false, {}, :unauthorized
    end
  end

  private

  def load_book
    @book = Book.find_by(id: params[:book_id])
    unless @book.present?
      json_response "Cannot find Book", false, {}, :not_found
    end 
  end

  def load_review
    @review = Review.find_by(id: params[:id])
    unless @review.present?
      json_response "Cannot find Review", false, {}, :not_found
    end
  end

  def review_params
    params.require(:review).permit(:title, :content_rating, :recommend_rating)
  end
end