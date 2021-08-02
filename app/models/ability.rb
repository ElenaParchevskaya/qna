# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      # can :read, :all
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    can :create, [Question, Answer, Comment]

    can %i[update destroy], [Question, Answer, Vote], user_id: user.id

    can :destroy, ActiveStorage::Attachment, record: { user_id: user.id }
    can :destroy, Link, linkable: { user_id: user.id }

    can :mark_best, Answer, question: { user_id: user.id }

    can :create_vote, [Question, Answer] do |votable|
      votable.user_id != user.id
    end

    # can :read, :all
    guest_abilities
  end

  def admin_abilities
    can :manage, :all
  end
end
