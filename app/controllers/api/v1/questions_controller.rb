module Api
  module V1
    class QuestionsController < BaseController
      load_and_authorize_resource

      def index
        render json: Question.all, each_serializer: QuestionListSerializer
      end

      def show
        render json: @question
      end

      def create
        @question = current_resource_owner.questions.build(question_params)
        save_and_render(@question, :created)
      end

      def update
        @question.attributes = question_params
        save_and_render(@question)
      end

      def destroy
        @question.destroy
        head :no_content
      end

      private

      def question_params
        params.require(:question).permit(:title, :body, links_attributes: %i[name url])
      end
    end
  end
end
