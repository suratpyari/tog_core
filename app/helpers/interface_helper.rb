module InterfaceHelper
  
  def render_flash_messages
    flash.collect{|entry|
      content_tag(:div, entry[1], :class => "notice #{entry[0]}")
    }
  end
  
  def current_url?(options)
    url = case
    when Hash
      url_for options
    else
      options.to_s
    end
    request.request_uri =~ Regexp.new('^' + Regexp.quote(clean(url)))
  end
  
  def links_for_navigation(section)
    tabs = Tog::Interface.sections(section).tabs
    links = tabs.map do |tab|
      nav_link_to(tab)
    end.compact
  end
  
  def nav_link_to(tab)
    if request.request_uri.match(/#{tab.name.downcase}/) || ((request.request_uri == "/" or request.request_uri == "" ) and tab.name == "Home")
      content_tag(:li, %{#{link_to tab.name, tab.url} #{sub_nav_links_to(tab.items)}}, :class=>"on")
    else
      content_tag(:li, link_to(tab.name, tab.url))
    end
  end
  
  def sub_nav_links_to(tabs)
    unless tabs.empty?
      content_tag :ul do
        tabs.collect do |t|
          %{<li #{"class=\"on\"" if current_url?(t[1])}>#{ link_to t[0], t[1]}</li>}
        end
      end
    end
  end
  
  def columns_distribution
    @columns_distribution || "col_60_40"
  end
end
