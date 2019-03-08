Py3o.Fusion
===========

Generate PDF from ODF via Py3o.Fusion

Usage
-----

```ruby
require 'rubygems'
require_relative 'py3o_fusion'

data = {
  item: {
    fieldname: 'Replacement text',
  }
}
image = File.open('logo.png')

Py3oFusion.new('http://localhost:8765/form')
  .template("template.odt")
  .static_image("logo", image)
  .data(data)
  .generate_pdf('output.pdf')
```
