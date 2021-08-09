class SearchService
  def initialize(query, resources)
    @classes = [resources].flatten.compact.map(&:classify).map(&:constantize)
    @query = ThinkingSphinx::Query.escape(query)
  end

  def call
    @records = ThinkingSphinx.search(@query, classes: @classes)
  end
end
