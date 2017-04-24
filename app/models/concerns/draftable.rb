module Draftable
  extend ActiveSupport::Concern

  # Save value for a column as a draft
  def draft(column, value)
    current_value = self[column]

    if current_value.present? && current_value != value
      self[draft_col_name(column)] = value
    else
      self[column] = value
    end
    self
  end

  # Accept draft column
  def accept_draft_column(column)
    draft_col = draft_col_name(column)
    self[column] = self[draft_col]
    self[draft_col] = nil
    self
  end

  # Accept all draft columns
  def accept_draft
    draft_columns.each do |draft_column|
      column = draft_column.first.sub('_draft', '')
      accept_draft_column(column)
    end
    self
  end

  # Are there any unsaved drafts?
  def pending_drafts?
    draft_columns.any? do |column|
      self[column].nil?
    end
  end

  private

  def draft_col_name(column)
    "#{column}_draft"
  end

  def draft_columns
    attributes.select { |attr| attr =~ /(.*)_draft/ }
  end
end
