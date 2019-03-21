require 'asciidoctor'
require 'asciidoctor/extensions'
require 'asciidoctor/helpers'

class PageListBlockMacro < Asciidoctor::Extensions::BlockMacroProcessor
  use_dsl

  named :page_list_macro

  def process parent, target, attrs
    includeChild = (attrs.has_key? 'includeChild') ? attrs['includeChild']=='true' : false
    # puts("engine.site.git_url: #{engine.site.git_url}")
# puts("parent.document: #{parent.document}")
    html = Awestruct::Extensions::PageList.page_list_with_site(Awestruct::Engine.instance.site,target,includeChild)

    create_pass_block parent, html, attrs, subs: nil
  end

end