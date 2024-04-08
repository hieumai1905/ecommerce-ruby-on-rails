document.addEventListener("DOMContentLoaded", function () {
    var sizeLabels = document.querySelectorAll(".product__details__option__size label");
    var currentSizeInput = document.getElementById("current_size");
    var btnAddToCart = document.getElementById("btn-AddToCart");

    sizeLabels.forEach(function (label) {
      label.addEventListener("click", function () {
        var size = label.textContent.trim();
        currentSizeInput.value = size;
        updateActiveLabel(label);
        choseDetailProduct();
      });
    });

    function updateActiveLabel(clickedLabel) {
      sizeLabels.forEach(function (label) {
        label.classList.remove("active");
      });

      clickedLabel.classList.add("active");
    }

    var colorLabels = document.querySelectorAll(".product__details__option__color label");
    var currentColorInput = document.getElementById("current_color");

    colorLabels.forEach(function (label) {
      label.addEventListener("click", function () {
        var color = label.classList[0];
        currentColorInput.value = color;
        updateSelectedColor(label);
        choseDetailProduct()
      });
    });

    function updateSelectedColor(clickedLabel) {
      colorLabels.forEach(function (label) {
        label.classList.remove("zoomed");
      });

      clickedLabel.classList.add("zoomed");
    }

    function choseDetailProduct() {
      var selectedColor = splitColorName(currentColorInput.value);
      var selectedSize = getSelectedSize(currentSizeInput.value);
      var productId = document.getElementById("product_id").value;
      if (selectedColor !== -1 && selectedSize !== -1) {
        getInfoProductDetail(productId, selectedColor, selectedSize);
      } else if (selectedColor !== -1) {
        getInfoProductDetail(productId, selectedColor);
      } else if (selectedSize !== -1) {
        getInfoProductDetail(productId, null, selectedSize);
      }
    }

    function getInfoProductDetail(productId, color = null, size = null) {
      var url = '/products/' + productId + '/details';

      var queryParams = [];
      if (color) {
        queryParams.push('color=' + color);
      }
      if (size) {
        queryParams.push('size=' + size);
      }

      if (queryParams.length > 0) {
        url += '?' + queryParams.join('&');
      }

      $.ajax({
        url: url,
        type: 'GET',
        success: function (data) {
          var quantity = data.quantity;
          var quantityCurrent = $("#quantity_current");
          $("#quantity_product").text(quantity).show();
          var productDetails = data.product_details;
          quantityCurrent.attr("max", quantity);
          if (productDetails.length === 1 && quantity > 0 && currentColorInput.value !== "" && currentSizeInput.value !== "") {
            $("#product_detail_id_current").val(productDetails[0].id);
            $("#price_current").text('$' + productDetails[0].price);
          }
          if (quantity === 0) {
            $("#product_detail_id_current").val("");
            quantityCurrent.val(0);
          } else {
            $("#quantity_current").val(1);
          }
        },
        error: function (error) {
          console.log(error);
        }
      });
    }

    btnAddToCart.addEventListener("click", function () {
      var selectedColor = splitColorName(currentColorInput.value);
      var selectedSize = getSelectedSize(currentSizeInput.value);
      if (selectedColor === -1 || selectedSize === -1) {
        alert("Please choose color and size");
        return;
      }

      var productDetailId = $("#product_detail_id_current").val();

      if (productDetailId === "") {
        alert("This product is out of stock");
        return;
      }

      var quantity = $("#quantity_current").val();
      var url = '/carts';
      var csrfToken = $('meta[name="csrf-token"]').attr('content');
      $.ajax({
        url: url,
        type: 'POST',
        data: {
          authenticity_token: csrfToken,
          product_detail_id: productDetailId,
          quantity: quantity
        },
        success: function (response) {
          alert(response.message);
          updateCountCartItem();
        },
        error: function (error) {
          console.error(error);
          alert("add to cart fail")
        }
      });

    });
    $('#quantity_current').on('change', function () {
      var quantityProduct = $('#quantity_product').text();
      var quantityCurrent = parseInt($(this).val());

      if (quantityProduct === '') {
        alert('Please select product details.');
        $(this).val(0);
      } else if (quantityCurrent > parseInt(quantityProduct)) {
        alert('Maximum ' + quantityProduct + ' items can be selected.');
        $(this).val(quantityProduct);
      }
    });
  }
);

function splitColorName(color) {
  let colorName = color.split("-")[2];
  return colorName || -1;
}

function getSelectedSize(size) {
  return size || -1;
}

function updateCountCartItem() {
  var url = '/carts/count';
  $.ajax({
    url: url,
    type: 'GET',
    success: function (response) {
      $("#cart_product_count").text(response.count);
    },
    error: function (error) {
      console.error(error);
    }
  });
}
