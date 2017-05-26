# Gets an object and params with list of values to update
# When column is draftable (has _draft column as well) we will clear it
class OverrideDraft
  attr_reader :object, :params

  def initialize(object, params)
    @object = object
    @params = params
  end

  def call
    assign_new_values
    clear_draft_values
    object.save
  end

  private

  def assign_new_values
    object.attributes = params
  end

  def clear_draft_values
    params.each do |column, _value|
      draft_column = "#{column}_draft"
      object[draft_column] = nil if object.has_attribute?(draft_column)
    end
  end
end
