$(document).on('turbolinks:load', function() {
  const voteLink = (name, status, vote) => `<a data-type='json' class='vote-link' data-remote='true' rel='nofollow' data-method='post' href='/votes?status=${status}&amp;votable_id=${vote.votable_id}&amp;votable_type=${vote.votable_type}' >${name}</a>`

  const voteCancelLink = (vote) => `<a data-type="json" class="cancel-vote-link" data-remote="true" rel="nofollow" data-method="delete" href="/votes/${vote.id}">Cancel</a>`

  $('body').on('ajax:success', '.vote-link', (event) => {
    let vote = event.detail[0].vote
    let rating = event.detail[0].rating
    let message = vote.status === 'like' ? 'You like it!' : 'You dislike it!';
    let vote_block = $(`#votable-${vote.votable_type.toLowerCase()}-${vote.votable_id}`);
    vote_block.find(".vote").html(message + voteCancelLink(vote))
    vote_block.find(".vote-rating").html(`Rating: ${rating}`)
  })

  $('body').on('ajax:success', '.cancel-vote-link', (event) => {
    let vote = event.detail[0].vote
    let rating = event.detail[0].rating
    let vote_block = $(`#votable-${vote.votable_type.toLowerCase()}-${vote.votable_id}`);
    vote_block.find(".vote").html(voteLink('Like', 'like', vote) + voteLink('Dislike', 'dislike', vote))
    vote_block.find(".vote-rating").html(`Rating: ${rating}`)
  })
});
