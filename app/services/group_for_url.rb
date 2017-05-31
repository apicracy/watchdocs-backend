class GroupForUrl
  def initialize(url:, project:)
    @url = url
    @project = project
  end

  def call
    create_group
  end

  private

  def create_group
    @group = Group.find_or_create_by!(
      name: parse_name,
      project: @project
    )
  end

  def version?(element)
    pattern = /v[0-9]/
    element =~ pattern
  end

  def api?(element)
    pattern = 'api'
    element.eql? pattern
  end

  def split_url
    arr = @url.split('/')
    arr.shift(1)
    arr
  end

  def parse_name
    arr = split_url
    if api? arr.first
      version?(arr.second).present? ? arr.shift(2) : arr.shift(1)
    elsif version? arr.first
      arr.shift(1)
    else
      arr
    end
    arr.first.humanize
  end
end
