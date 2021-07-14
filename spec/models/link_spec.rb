require 'rails_helper'

RSpec.describe Link, type: :model do
  subject { build(:link) }

  describe 'associations' do
     it { is_expected.to belong_to :linkable }
   end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :url }
    it { should allow_value('https://thinknetica.com/').for(:url) }
    it { is_expected.not_to allow_value('htps://thinknetica.com/').for(:url) }
  end
end
