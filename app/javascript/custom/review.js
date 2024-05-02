function getDataReview(bill_id, product_detail_id) {
  let url = '/bills/' + bill_id +'/reviews/products/' + product_detail_id;
  $.ajax({
    url: url,
    type: 'GET',
    success: function (data) {
      if (data != null){
        $("#review_id").val(data.id)
        $("#review_content").text(data.comment);
        let rating = data.rating;
        $("#rate_value").val(rating);

        let starHTML = '';
        for (let i = 1; i <= 5; i++) {
          if (i <= rating) {
            starHTML += '<i class="fa fa-star"></i>';
          } else {
            starHTML += '<i class="fa fa-star-o text-muted"></i>';
          }
        }
        $("#review_rate").html(starHTML);
        startEventClick();
      }
    }
  });
  startEventClick();
}

function startEventClick(){
  $("#review_rate i").click(function () {
    let clickedIndex = $(this).index();

    rating = clickedIndex + 1;
    $("#review_rate i").each(function (index) {
      if (index <= clickedIndex) {
        $(this).removeClass("fa-star-o").addClass("fa-star");
      } else {
        $(this).removeClass("fa-star").addClass("fa-star-o");
      }
    });
    $("#rate_value").val(rating);
  });
}
