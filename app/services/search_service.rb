class SearchService
  def initialize(query, resources)
    # @classes = [resources].flatten.compact.map(&:classify).map(&:constantize)
    @classes = [resources].flatten.compact.map do |s|
      s.classify.constantize
    end
    @query = ThinkingSphinx::Query.escape(query)
  end

  def call
    @records = ThinkingSphinx.search(@query, classes: @classes)
  end
end
