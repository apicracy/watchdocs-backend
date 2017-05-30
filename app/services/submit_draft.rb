# Gets an object and params to update
# if corresponding column is draftable (has _draft column as well)
# we will try to save it as draft
class SubmitDraft
  attr_reader :object, :params

  def initialize(object, params)
    @object = object
    @params = params
  end

  def call
    params.each do |column, value|
      assign_value(column, value)
    end
    object.save
  end

  private

  def assign_value(column, value)
    draft_column = "#{column}_draft"
    previous_value = object[column]

    if object.has_attribute?(draft_column) &&
       previous_value.present? &&
       value != previous_value
      object[draft_column] = value
    else
      object[column] = value
    end
  end
end
