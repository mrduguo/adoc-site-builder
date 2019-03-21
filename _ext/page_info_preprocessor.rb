require 'asciidoctor'
require 'asciidoctor/extensions'

class PageInfoPreprocessor < Asciidoctor::Extensions::Preprocessor

  @@page_orders =Hash.new

  def process document, reader
    lines = reader.lines # get raw lines
    return reader if lines.empty?
    # puts("file_location = #{Pathname.new Dir.pwd}")
    # puts("file_location = #{document}")
    # puts("file_location = #{document.inspect}")
    # puts("file_location reader= #{reader}")
    # puts("file_location file = #{reader.file}")
    # puts("file_location path = #{reader.path}")
    page_layout=nil
    page_title=nil
    page_order=nil
    lines.each do |line|
      if page_layout==nil and line.start_with? ':page-layout:'
        page_layout=line[14..-1].strip
      end
      if page_order==nil and line.start_with? ':page-order:'
        page_order=line[13..-1].strip
      end
      if page_title==nil and line.start_with? '= '
        page_title=line[2..-1].strip
      end
    end
    if page_layout==nil
      document.set_attribute('page-layout',"doc")
    end
    if page_order!=nil and page_title!=nil
      @@page_orders[page_title]=page_order
    end
    document.set_attribute('imagesdir',"/foo/bar/")
    reader
  end



  def self.get_page_order_value(page_title)
    if @@page_orders[page_title]!=nil
      return @@page_orders[page_title]
    else
      return page_title
    end
  end
end