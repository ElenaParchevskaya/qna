import consumer from "./consumer"

consumer.subscriptions.create("QuestionChannel", {
  connected() {
    let question = document.querySelector('.question')

    if (question) {
      let id = question.id.split('-')[1]
      this.perform('follow_question', { id: id })
    }
  },

  disconnected() {
  },

  received(data) {
    if (data.user_id === gon.user_id) return;
    if (data.commentable_id) appendComment(data);

    appendAnswer(data);
  }
});

function appendComment(data){
  $(`#${data.commentable_type.toLowerCase()}-${data.commentable_id}-comments`).find(".comments-list").append(data.comment)
}

function appendAnswer(data){
  $(".answers").append(data.answer)
}
