$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();

    const answerId = $(this).data('answerId');

    if ($(`#answer-${answerId} .hidden`).is(":hidden")) {
      $(`#answer-${answerId} .hidden`).show()
      $(`.answers #answer-${answerId} input[type=submit]`).val('Edit')
    } else {
      $(`#answer-${answerId} .hidden`).hide()
    }
  })
});
