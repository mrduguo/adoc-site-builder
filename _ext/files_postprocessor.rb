require 'asciidoctor'
require 'asciidoctor/extensions'


# fix the draw.io image relative paths
# support image reference in folder named draw e.g.
# image::draw/reference-architecture.png[Reference Architecture]
class FilesPostprocessor < Asciidoctor::Extensions::Postprocessor
  def process document, output
      base_path=(document.reader.path=='index.adoc')?'./files/':'../files/'
      diagram_path="#{Awestruct::Engine.instance.site.context_path}/images/diagrams/"
      output.gsub('/images/diagrams/files/', base_path).gsub('/images/diagrams/', diagram_path)
  end
end