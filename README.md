Py3o.Fusion
===========

[![Gem Version](https://badge.fury.io/rb/py3o_fusion.svg)](https://badge.fury.io/rb/py3o_fusion)

Generate PDF from ODF via Py3o.Fusion and replace text fields and images.

See [Py3o.Fusion](https://bitbucket.org/faide/py3o.fusion) for more
information.

Usage
-----

### Constructor

Instantiate with URL to Py3o.Fusion form endpoint.

```ruby
    py3ofusion = Py3oFusion.new('http://localhost:8765/form')
```

### template(path)

Set path to ODF template file to use.

#### Example

Reads the file named `template.odt` and uses it as the template to generate
PDF from.

```ruby
    py3ofusion.template("template.odt")
```

### data(hash)

Data dictionary with variables to replace in the ODF document.

#### Example

Replaces the text field named `py3o.item.fieldname` with the text `Replacement
text`.

```ruby
    py3ofusion.data({
      item: {
        fieldname: 'Replacement text'
      }
    })
```

### static_image(name, path)

Replace an image with the name `py3o.staticimage.` prefixed to `image_name`.

#### Example

Replaces the image named `py3o.staticimage.logo` with the file at path
`logo.png`.

```ruby
    py3ofusion.static_image("logo", "logo.png")
```

### generate_pdf(path)

Send the data to Py3o.Fusion to replace fields and images, and generate a PDF
file that will be saved at `output_path`.

```ruby
    py3ofusion.generate_pdf('output.pdf')
```

### Complete example

A complete use, chaining methods together.

```ruby
    require 'py3o_fusion'

    data = {
      item: {
        fieldname: 'Replacement text'
      }
    }

    Py3oFusion.new('http://localhost:8765/form')
      .template("template.odt")
      .static_image("logo", 'logo.png')
      .data(data)
      .generate_pdf('output.pdf')
```

