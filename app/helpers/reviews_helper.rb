module ReviewsHelper
  def render_rating rating
    stars = []
    rating.times do
      stars << tag.i(nil, class: "fa fa-star text-warning")
    end
    (5 - rating).times do
      stars << tag.i(nil, class: "fa fa-star-o text-muted")
    end
    safe_join(stars)
  end
end
