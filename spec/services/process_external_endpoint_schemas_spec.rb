require 'rails_helper'

RSpec.describe ProcessExternalEndpointSchemas do
  RSpec::Matchers.define_negated_matcher :not_change, :change

  let(:schemas) { external_schema_fixture(:full) }
  subject(:processor) { described_class.new(schemas) }

  context 'when project doesnt exists' do
    it 'raises exception' do
      expect { processor.call }
        .to raise_error(ProjectNotFound)
        .and not_change { Endpoint.count }
    end
  end

  context 'when project exists' do
    before { Fabricate(:project, app_id: 'TEST') }

    context 'and schemas are for success new endpoint call' do
      before do
        processor.call
      end

      it 'creates new endpoint' do
        expect(Endpoint.last.url).to eq(schemas[:endpoint][:url])
      end

      it 'creates new response with body for endpoint' do
        endpoint = Endpoint.last
        expect(endpoint.responses.count).to eq(1)
        expect(endpoint.responses.last.http_status_code).to eq schemas[:response][:status]
        expect(endpoint.responses.last.body).to eq schemas[:response][:body]
      end

      it 'creates all headers for response' do
        response = Endpoint.last.responses.last
        expect(response.headers.count).to eq(7)
        expect(response.headers.last.key).to eq('X-RUNTIME')
        expect(response.headers.all?(&:required)).to be_truthy
      end

      it 'creates request' do
        endpoint = Endpoint.last
        expect(endpoint.request).to be_present
        expect(endpoint.request.body).to eq schemas[:request][:body]
      end

      it 'creates all headers for request' do
        request = Endpoint.last.request
        expect(request.headers.count).to eq(7)
        expect(request.headers.last.key).to eq('X-RUNTIME')
        expect(request.headers.all?(&:required)).to be_truthy
      end

      it 'creates all url params' do
        endpoint = Endpoint.last
        expect(endpoint.url_params.count).to eq(4)
        expect(endpoint.url_params.last.key).to eq('data[attributes][output_currency]')
        expect(endpoint.url_params.all?(&:required)).to be_truthy
      end
    end

    context 'and schemas are for invalid new endpoint call' do
      let(:schemas) { external_schema_fixture(:response_only) }

      before do
        processor.call
      end

      it 'creates new endpoint' do
        expect(Endpoint.last.url).to eq(schemas[:endpoint][:url])
      end

      it 'creates new response with body for endpoint' do
        endpoint = Endpoint.last
        expect(endpoint.responses.count).to eq(1)
        expect(endpoint.responses.last.http_status_code).to eq schemas[:response][:status]
        expect(endpoint.responses.last.body).to eq schemas[:response][:body]
      end

      it 'creates all headers for response' do
        response = Endpoint.last.responses.last
        expect(response.headers.count).to eq(7)
        expect(response.headers.last.key).to eq('X-RUNTIME')
        expect(response.headers.all?(&:required)).to be_truthy
      end

      it 'does not create request' do
        endpoint = Endpoint.last
        expect(endpoint.request).to be_nil
      end
    end
  end
end
