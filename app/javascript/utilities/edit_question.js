$(document).on('turbolinks:load', function() {
  $('.question').on('click', '.edit-question-link', function(e) {
    e.preventDefault();

    const questionId = $(this).data('questionId');

    if ($(`#question-${questionId} .hidden`).is(":hidden")){
      $(`#question-${questionId} .hidden`).show()
      $(`#question-${questionId} .hidden input[type=submit]`).val('Edit')
    } else {
      $(`#question-${questionId} .hidden`).hide()}
  })
});
