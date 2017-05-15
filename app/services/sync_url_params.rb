class SyncUrlParams
  attr_reader :endpoint

  def initialize(endpoint)
    @endpoint = endpoint
  end

  def call
    generate_new_params_from_url
    mark_stale
  end

  private

  def generate_new_params_from_url
    new_params.each { |param| sync_param(param) }
  end

  def new_params
    @new_params ||= endpoint.url
                            .scan(/:{1}[A-Za-z0-9\-_\.~]+/)
                            .map { |param| param.reverse.chop.reverse }
  end

  def sync_param(param)
    endpoint.url_params
            .url_members
            .find_or_initialize_by(name: param)
            .update(
              required: true,
              status: :up_to_date,
              is_part_of_url: true
            )
  end

  def mark_stale
    return if endpoint.url_params.empty?
    endpoint.url_params
            .url_members
            .not_stale
            .where.not(name: new_params)
            .update(
              required: false,
              status: :stale
            )
  end
end
