require 'asciidoctor'
require 'asciidoctor-diagram'
require 'asciidoctor/extensions'
require 'awestruct/handlers/template/asciidoc'
require 'page_list_macro'
require 'page_info_preprocessor'
require 'draw_image_postprocessor'

# Monkeypatch the AsciidoctorTemplate class from Awestruct to register Asciidoctor::Document object in page context.
# Remove this hack when issue [1] will be resolved and available in a release.
# [1] https://github.com/awestruct/awestruct/issues/288
class Awestruct::Tilt::AsciidoctorTemplate
  def evaluate(scope, locals)
    @output ||= (scope.document = ::Asciidoctor.load(data, options)).convert
  end
end

#require 'open-uri/cached'
#OpenURI::Cache.cache_path = ::File.join Awestruct::Engine.instance.config.dir, 'vendor', 'uri-cache'

Asciidoctor::Extensions.register do
  # workaround for Awestruct 0.5.5
  # (change lib/awestruct/handlers/asciidoctor_handler.rb, line 108 to opts[:base_dir] = @site.config.dir unless opts.key? :base_dir)
  if (docfile = @document.attributes['docfile'])
    @document.instance_variable_set :@base_dir, File.dirname(docfile)
  end
  preprocessor PageInfoPreprocessor
  block_macro PageListBlockMacro
  postprocessor DrawImagePostprocessor

  #
  # # fix the draw.io image relative paths
  #   postprocessor {
  #     process {|doc, output|
  #       base_path=(doc.reader.path=='index.adoc')?'./draw/':'../draw/'
  #       %(#{output.gsub('/images/draw/', base_path)})
  #     }
  #   }

end

module Awestruct
  class Engine
    def development?
      site.profile == 'development'
    end
  end
end
