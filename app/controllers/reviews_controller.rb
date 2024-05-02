class ReviewsController
  def create
    @review = Review.new(review_params)
    if @review.save
      redirect_to @review.product, notice: "Review was successfully created."
    else
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:product_id, :rating, :comment)
  end
end
