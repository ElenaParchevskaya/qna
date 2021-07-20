$(document).on('turbolinks:load', function() {
  const voteLink = (name, status, vote) => `<a data-type='json' class='vote-link' data-remote='true' rel='nofollow' data-method='post' href='/votes?status=${status}&amp;votable_id=${vote.votable_id}&amp;votable_type=${vote.votable_type}' >${name}</a>`

  const voteCancelLink = (vote) => `<a data-type="json" class="cancel-vote-link" data-remote="true" rel="nofollow" data-method="delete" href="/votes/${vote.id}">Cancel</a>`

  $('body').on('ajax:success', '.vote-link', (event) => {
    vote = event.detail[0].vote
    rating = event.detail[0].rating
    message = vote.status === 'like' ? 'You like it!' : 'You dislike it!';
     $(".vote").html(message + voteCancelLink(vote))
     $(".vote-rating").html(`Rating: ${rating}`)
  })

  $('body').on('ajax:success', '.cancel-vote-link', (event) => {
    vote = event.detail[0].vote
    rating = event.detail[0].rating
    $(".vote").html(voteLink('Like', 'like', vote) + voteLink('Dislike', 'dislike', vote))
    $(".vote-rating").html(`Rating: ${rating}`)
  })
}); 
