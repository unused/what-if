# frozen_string_literal: true

# Handles user choices
class UsersChoiceSelectService
  def initialize(user)
    @user = user
  end

  def call(request)
    Rails.logger.info "[DEBUG] passage: #{@user.passage.ref}"
    Rails.logger.info "[DEBUG] decision: #{request.slot(:decision)}"
    Rails.logger.info "[DEBUG] query: #{request.slot(:query)}"
    handle_choice request
    Rails.logger.info "[DEBUG] changed to passage: #{@user.passage.ref}"
  end

  def handle_choice(request)
    # TODO: Rename decision to ordinal
    if request.slot(:decision).present?
      update_by_ordinal request.slot(:decision)
    end
    update_by_query request.slot(:query) if request.slot(:query).present?
  end

  def update_by_ordinal(ordinal)
    update @user.passage.choices[ordinal.to_i - 1]
  end

  def update_by_query(query)
    choice = QueryMatcher.new(@user.passage.choices).match query
    return unless choice

    update choice
  end

  def update(choice)
    return unless choice

    @user.passage = @user.story.find_passage choice.ref
    @user.save
  end
end
