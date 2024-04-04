document.addEventListener("DOMContentLoaded", function () {
    var sizeLabels = document.querySelectorAll(".product__details__option__size label");
    var currentSizeInput = document.getElementById("current_size");

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
          $("#quantity_product").text(quantity).show();
        },
        error: function (error) {
          console.log(error);
        }
      });
    }
  }
);

function splitColorName(color) {
  let colorName = color.split("-")[2];
  return colorName || -1;
}

function getSelectedSize(size) {
  return size || -1;
}
