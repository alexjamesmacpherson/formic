module ApplicationHelper
  #Define title of page, must assert <% provide(:title, 'Home') %> in all views
  def full_title(page_title = '')
    base_title = 'Formic Learning'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end
end
