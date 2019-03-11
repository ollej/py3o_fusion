require 'spec_helper'

RSpec.describe Py3oFusion do
  subject {
    described_class.new('http://localhost:8765/form')
      .template(template)
      .data(data)
      .static_image("test_image", image)
  }

  after(:each) do
    generated_pdf.unlink
    template.unlink
    image.unlink
  end

  let(:generated_pdf) { Tempfile.new('output.pdf') }
  let(:template) { Tempfile.new('template.odt') }
  let(:image) { Tempfile.new('image.png') }
  let(:data) do
    {
      foo: "bar"
    }
  end
  let(:response) { instance_double(HTTParty::Response, body: response_body, code: 200) }
  let(:response_body) { 'foo bar baz' }

  describe '#generate_pdf' do
    it "posts data to Py3o.Fusion endpoint" do
      expect(HTTParty).to receive(:post) do |endpoint, payload|
        expect(payload[:body]).to include(
          targetformat: "pdf",
          datadict: data.to_json,
          image_mapping: {
            test_image: "staticimage.test_image"
          }.to_json
        )
        expect(payload[:body]).to have_key(:tmpl_file)
        expect(payload[:body]).to have_key(:test_image)
      end.and_return(response)
      subject.generate_pdf(generated_pdf.path)
      generated_pdf.rewind
      expect(generated_pdf.read).to eq 'foo bar baz'
    end

    it "parses error response" do
      error_json = JSON.dump({
        'error' => true,
        'reasons' => ['TemplateException()']
      })
      error_response = double('Response', body: error_json, code: 400)
      allow(subject).to receive(:post).and_return error_response
      expect {
        subject.generate_pdf(generated_pdf.path)
      }.to raise_error Py3oFusion::Error, 'Error generating PDF: ["TemplateException()"]'
    end
  end

  context 'with logger' do
    subject {
      described_class.new('http://localhost:8765/form', logger: logger)
        .template(template)
        .data(data)
        .static_image("test_image", image)
    }
    let(:logger) { double('Logger').as_null_object }

    it 'sends logger object to HTTParty post' do
      expect(HTTParty).to receive(:post) do |endpoint, options|
        expect(options).to include(logger: logger)
      end
      subject.send(:post)
    end
  end
end
