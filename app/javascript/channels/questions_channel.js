import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    //when the subscription is ready for use on the server
  },

  disconnected() {
    //when the subscription has been terminated by the server
  },

  received(data) {
    $(".questions").append(data.question_item)
  }
});
