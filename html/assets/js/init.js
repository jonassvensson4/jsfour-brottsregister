$(document).ready(function(){
  // Client listener
  window.addEventListener('message', function(event) {
      if (event.data.action == 'open') {
        $('body').show();
        $('#player-search').show();
      } else if (event.data.action == 'playerFound') {
        $('#player-search').hide();
        $('#name').text(event.data.array[0].firstname + ' ' + event.data.array[0].lastname);
        $('#personummer-span').text($('#personnummer').val());
        for (var i = 0; i < event.data.array.length; i++) {
          $('tbody').append('<tr><td>'+event.data.array[i].dateofcrime+'</td><td>'+event.data.array[i].crime+'</td></tr>');
        }
        $('#player-found').show();
        $('#search-icon').show();
      } else if (event.data.action == 'playerNull') {
        $('#player-search').hide();
        $('#personummer-span').text($('#personnummer').val());
        $('#player-null').show();
        $('#search-icon').show();
      }
  });

  // Search button
  $('#button-search').click(function() {
    var search = $('#personnummer').val();
    if (search.includes('-')) {
    	var result = search.split('-');
      var pNumb = result[0] +'-'+ result[1] +'-'+ result[2];
      var digits = result[3];
    } else {
    	var pNumb = search.substring(0,4) +'-'+  search.substring(4,6) +'-'+ search.substring(6,8);
      var digits = search.substring(8,12);
    }
    if (search != '') {
      $.post('http://jsfour-brottsregister/search', JSON.stringify({
        personnummer: pNumb,
        lastdigits: digits
      }));
    }
  });

  $('#search-icon').click(function() {
    resetAll()
    $('body').show();
    $('#player-search').show();
  });

  function resetAll() {
    $('body').hide();
    $('#player-found').hide();
    $('#player-null').hide();
    $('#player-search').hide();
    $('#search-icon').hide();
    $('#personnummer').val('');
    $('#name').text('');
    $('tbody').html('');
  }

  // Escape key event + reset the page
  $(document).keyup(function(e) {
     if (e.keyCode == 27) {
      resetAll()
      $.post('http://jsfour-brottsregister/escape', JSON.stringify({}));
    }
  });

  // Disable space on the input
  $("form").on({
	  keydown: function(e) {
	    if (e.which === 32)
	      return false;
	  },
	});
  // Disable form submit
  $("form").submit(function() {
		return false;
	});
});
