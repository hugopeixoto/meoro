// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(function() {
  var minSlide = 1;
  var maxSlide = 100;

  userInfo();

  $("#slider").slider({
    range: true,
    min: minSlide,
    max: maxSlide,
    step: 0,
    values: [minSlide, maxSlide],
    slide: function(event, ui) {
      var delay = function() {
        var label;
        if(minSlide != parseInt(ui.values[0], 10)){
          label = "#min";
        }
        else if(maxSlide != parseInt(ui.values[1], 10)) {
          label = "#max";
        }
  $(label).html(ui.value).position({
    my: 'center top',
    at: 'center bottom',
    of: ui.handle,
    offset: "0, 10"
  });

  $(label).val(ui.value);
      };

      // wait for the ui.handle to set its position
      setTimeout(delay, 5);
    },
    stop: function(event, ui){
      minSlide = parseInt(ui.values[0], 10);
      maxSlide = parseInt(ui.values[1], 10);               
    }
  });

  $('#min').html($('#slider').slider('values', 0)).position({
    my: 'center top',
    at: 'center bottom',
    of: $('#slider a:eq(0)'),
    offset: "0, 10"
  });
  $("#min").val(minSlide);

  $('#max').html($('#slider').slider('values', 1)).position({
    my: 'center top',
    at: 'center bottom',
    of: $('#slider a:eq(1)'),
    offset: "0, 10"
  });
  $("#max").val(maxSlide);

  $(".betButton").click(function (e) {
    amount = $(e.currentTarget).data("amount");
    bet(amount);
  });

  function bet(value)
  {
    $.ajax({
      type:"POST",
      url: "/api/v1/bets",
      data: {
        user:{
          token: window.userToken
        }, 
      bet:{
        amount: value,
      high: $("#max").val(),
      low: $("#min").val()
      }
      },
      dataType: 'json',
      success: function (result) {
        $('#userName').html(result.user.name);
        $('#userBalance').html(result.user.balance);

        var value = result.bet.prize - result.bet.amount;
        flyValue($("#userContainer"), value, {left: 100, top: 0}, {direction: "down"});

        var x_position = result.bet.roll * $("#slider").width() / 100;
        flyValue($("#slider"), result.bet.roll, {left: x_position, top: 0});
      },
      error: function (xhr, ajaxOptions, thrownError) {
      }
    });
  };

  function userInfo()
  {
    $.ajax({
      type: "GET",
      url: "/api/v1/users/" + window.userToken,
      dataType: 'json',
      success: function (result) {
        $('#userName').html(result.name);
        $('#userBalance').html(result.balance);
      },
      error: function (xhr, ajaxOptions, thrownError) {
      }
    });
  }

  function flyValue(element, value, offset, options) {
    var elc = $("<div class='floatingText'></div>")
    var opts = options || {direction: "up"};

    elc.html(value);
    element.append(elc);

    elc.show();

    elc.offset({
      left: element.offset().left + offset.left,
      top: element.offset().top + offset.top
    })

    var end_x = element.offset().left + offset.left;

    var end_y = 0;
    
    if(opts.direction === "up") {
      end_y = element.offset().top - 150;
    } else {
      end_y = element.offset().top + 150;
    }
    
    elc.css('opacity', 100);

    elc.animate({
      'top': end_y.toString() + 'px', 
      'left': end_x.toString() + 'px',
      'opacity': 0
      }, 750, function() { 
        $(this).remove();
      }
    );
  }
});
