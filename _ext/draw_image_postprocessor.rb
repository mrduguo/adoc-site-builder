require 'asciidoctor'
require 'asciidoctor/extensions'


# fix the draw.io image relative paths
# support image reference in folder named draw e.g.
# image::draw/reference-architecture.png[Reference Architecture]
class DrawImagePostprocessor < Asciidoctor::Extensions::Postprocessor
  def process document, output
      base_path=(document.reader.path=='index.adoc')?'./files/':'../files/'
      output.gsub('/images/files/', base_path)
  end
end