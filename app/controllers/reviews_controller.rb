class ReviewsController < ApplicationController
  before_action :load_product, :load_review, only: %i(show create)

  def create
    if @review.present?
      handle_update_review
    else
      handle_create_review
    end
    redirect_to histories_path
  end

  def show
    render json: @review
  end

  private

  def load_product
    @product_detail = ProductDetail.find_by id: params[:product_detail_id]
    return if @product_detail

    flash[:danger] = t "pages.product.not_found"
    redirect_to histories_path
  end

  def load_review
    @review = Review.find_by(bill_id: params[:id],
                             product_id: @product_detail.product.id,
                             account_id: current_account.id)
  end

  def handle_update_review
    handle_build_review @review.update comment: params[:comment],
                                       rating: params[:rating]
  end

  def handle_create_review
    handle_build_review build_review.save
  end

  def build_review
    @review = Review.new(
      account_id: current_account.id,
      comment: params[:comment],
      rating: params[:rating],
      bill_id: params[:bill_id],
      product_id: @product_detail.product.id
    )
  end

  def handle_build_review condition
    if condition
      flash[:success] = t "pages.review.success"
    else
      flash[:danger] = @review.errors.full_messages.join(", ")
    end
  end
end
