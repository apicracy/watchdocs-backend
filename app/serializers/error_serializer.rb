class ErrorSerializer < ActiveModel::Serializer
  attributes :errors

  def errors
    {
      errors: {
        status: 400,
        title: 'Bad Request',
        detail: object.object.errors.messages,
        code: 100
      }
    }
  end
end
