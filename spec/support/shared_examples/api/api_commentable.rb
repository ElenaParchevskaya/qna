RSpec.shared_examples "API commentable" do
  context 'when it has any comments' do
    let!(:comments) { create_list :comment, 2, commentable: resource }
    let(:comment) { comments.first }
    let(:comments_json) { resource_json['comments'] }
    let(:comment_json) { comments_json.first }

    before { subject }

    it 'returns list of comments' do
      expect(comments_json.size).to eq comments.size
    end

    it 'returns attributes of each comment' do
      %w[id body created_at updated_at].each do |attr|
        expect(comment_json[attr]).to eq comment.send(attr).as_json
      end
    end

    it 'returns owner of comment as an user' do
      expect(comment_json['user']['id']).to eq comment.user.id
      expect(comment_json['user']['email']).to eq comment.user.email
    end
  end
end
