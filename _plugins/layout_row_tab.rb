
class LayoutRow < Liquid::Tag
  def initialize(tag_name, input, tokens)
    super
    @input = input
    @tokens = tokens
  end
  
  def lookup(context, name)
    lookup = context
    name.split(".").each { |value| lookup = lookup[value] }
    lookup
  end
  
  def render(context)
    columnMap = ["twelve", "six", "four", "three"]
    
    input_split = @input.split("|")
    
    start = input_split[0].strip.to_i
    cols  = input_split[1].strip.to_i
    
    baseUrl = lookup(context, 'site.baseurl')
    sitePosts = lookup(context, 'site.posts')
    i = start
    
    if start > sitePosts.length
      return ""
    end
    
    iterEnd = 0
    if sitePosts.length - 1 > start + cols
        iterEnd = start + cols
      else
        iterEnd = sitePosts.length - 1
        cols = iterEnd - start
    end
    
    output = ""

    until i >= iterEnd
      post = sitePosts[i]
      data = post.data
      output += "<a href=\"" + "#{baseUrl}" + "#{post.url}" + "\">\n"
      
      output += "<div class=\"" + columnMap[cols - 1] + " columns news-piece news-piece-2 "
      if i == start && cols == 3 || cols == 4
          output += "border-2"
        elsif i != start + cols - 1
          output += "border"
        else
        putc "testing"
      end
      
      output += "\" "
      
      output += "style=\"background-image:url(#{baseUrl}/img/#{data["img"]});\">\n"
      output += "<p class=\"news-title\">#{data["title"]}</p>\n"
      #Fix this by stripping the html from the excerpt.
      excerptHtml = post.data["excerpt"]
      excerpt = "#{excerptHtml}".gsub(/<\/?[^>]*>/, "")[0..80]
      output += "<p class=\"news-exp\">#{excerpt}</p>\n"
      output += "</div>\n"
      output += "</a>\n"
      
      i += 1
    end
    
    return output
  end
  
  
end

Liquid::Template.register_tag("layout_row", LayoutRow)
