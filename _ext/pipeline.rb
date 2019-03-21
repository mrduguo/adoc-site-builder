require 'compass'
require 'zurb-foundation'
require 'awestruct_ext'
require 'sass_functions'
require 'slim'
require 'page_list'
require 'breadcrumb'

Awestruct::Extensions::Pipeline.new do
  engine = Awestruct::Engine.instance

  helper Awestruct::Extensions::Partial
  helper Awestruct::Extensions::PageList
  helper Awestruct::Extensions::Breadcrumb
  # Indexifier *must* come before Atomizer
  extension Awestruct::Extensions::Indexifier.new

  #transformer Awestruct::Extensions::Minify.new([:js])
end
