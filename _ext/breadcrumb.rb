##
#
# Awestruct::Extensions:Breadcrumb is a helper type of awestruct extension.
# When used in Haml template, it will generate a breadcrumb navigation.
#
# Configuration:
#
# 1. configure the extension in the project pipeline.rb:
#    - add breadcrumb dependency:
#
#      require 'breadcrumb'
#
#    - add the extension initialization:
#
#      helper Awestruct::Extensions::Breadcrumb
#
# 2. In your Haml layout add:
#
#    = breadcrumb(page.output_path)
#
##

module Awestruct
  module Extensions
    module Breadcrumb

      def breadcrumb(path)

        return nil if !path or path.eql?("/") or path.eql?("/index.html")

        output = ""
        index = -1
        while index=path.index("/",index+1)

          parent_path = path[0..index] + "index.html"
          if page=findInPages(parent_path)
            output += generateAnchorHtml( page , parent_path.eql?(path) )
            next
          end

          parent_path = path[0..index-1] + ".html"
          if page=findInPages(parent_path)
            output += generateAnchorHtml( page , parent_path.eql?(path) )
            next
          end

        end

        if !parent_path.eql?(path)
          output += generateAnchorHtml( findInPages(path) , true )
        end
        output
      end


      def findInPages(path)

        for page in site.pages
          if page.output_path.eql?(path)
            return page
          end
        end
        nil
      end

      def generateAnchorHtml( page , isLast )

        path = (page.url.nil? ? page.output_path : page.url)

        return "" if path==nil

        if isLast or path.eql?("/")
          ""
        else
          " <a class='breadcrumb_anchor #{isLast ? "active" : ""}' href='#{site.context_path}#{path}'
        >#{page.title ? page.title : page.simple_name.capitalize }</a>"
        end



      end

    end
  end
end