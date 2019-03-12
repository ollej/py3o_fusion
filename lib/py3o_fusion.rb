require 'httparty'

class Py3oFusion
  class Error < StandardError; end

  def initialize(endpoint, options = {})
    @endpoint = endpoint
    @payload = {}
    @image_mapping = {}
    @options = options
  end

  def template(template)
    @payload[:tmpl_file] = File.open(template)
    self
  end

  def data(data)
    @data = data
    self
  end

  def static_image(name, file)
    @payload[name.to_sym] = File.open(file)
    @image_mapping[name.to_sym] = "staticimage.#{name}"
    self
  end

  def generate_pdf(path)
    response = post
    if response.code == 200
      store path, response.body
    else
      error = JSON.parse(response.body)
      raise Error.new "Error generating PDF: #{error['reasons']}"
    end
  end

  private
  def payload
    @payload.merge({
      targetformat: "pdf",
      datadict: @data.to_json,
      image_mapping: @image_mapping.to_json
    })
  end

  def post
    HTTParty.post @endpoint, @options.merge(body: payload)
  end

  def store(path, content)
    File.open(path, 'wb') { |file| file.write(content) }
  end
end
