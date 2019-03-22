
require 'page_info_preprocessor'

module Awestruct
  module Extensions
    module PageList

      def page_list(url,includeChild=false)
        return Awestruct::Extensions::PageList.page_list_with_site(site,url,includeChild)
      end


      def self.page_list_with_site(site,url,includeChild)

        output = "<ul>"
        sub_pages = []
        for page in site.pages
          if page.url.end_with? "/" and page.url.start_with? url and ((page.url.count "/")-1) == (url.count "/")
            sub_pages << page
          end
        end
        if !sub_pages.any?
          for page in site.pages
            if page.url.end_with? "/" and page.url.start_with? url and ((page.url.count "/")-2) == (url.count "/")
              sub_pages << page
            end
          end
        end
        if sub_pages.any?
          sub_pages
              .sort_by{ |p|PageInfoPreprocessor.get_page_order_value(p.title) }
              .each do |p|
                output+= "<li><a href='#{site.base_url}#{p.url}'>#{p.title}</a>"
                if includeChild
                  output+= page_list_with_site(site,p.url,includeChild)
                end
                output+= "</li>"
              end
        end
        return output+= "</ul>"
      end

    end
  end
end