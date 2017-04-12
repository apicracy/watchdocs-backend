require 'rails_helper'

RSpec.describe ProjectDetailedSerializer do
  subject(:serializer) { described_class.new(project) }
  let(:project) { Fabricate :project }

  describe '#to_json' do
    subject(:json) { JSON.parse(serializer.to_json) }

    it 'returns not grouped endpoints' do
      Fabricate :endpoint, url: '/contributions', project: project
      Fabricate :endpoint, url: '/pledges', project: project

      expect(json['tree']).to eq([{"id"=>1, "type"=>"Endpoint", "url"=>"/contributions", "method"=>"GET"}, {"id"=>2, "type"=>"Endpoint", "url"=>"/pledges", "method"=>"GET"}])
    end

    it 'returns grouped endpoints' do
      group = Fabricate :group, project: project
      Fabricate :endpoint, url: '/contributions', group: group
      Fabricate :endpoint, url: '/contributions/:id', group: group

      expect(json['tree']).to eq([{"id"=>1, "type"=>"Group", "items"=>[{"id"=>3, "type"=>"Endpoint", "url"=>"/contributions", "method"=>"GET"}, {"id"=>4, "type"=>"Endpoint", "url"=>"/contributions/:id", "method"=>"GET"}]}])
    end
  end
end
