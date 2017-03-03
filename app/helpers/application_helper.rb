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
  
  def score_to_grade(score)
    case score
      when 90..100
        'A*'
      when 80..89
        'A'
      when 70..79
        'B'
      when 60..69
        'C'
      when 50..59
        'D'
      when 40..49
        'E'
      when 30..39
        'F'
      when 10..29
        'U'
      else
        'X'
    end
  end
end
