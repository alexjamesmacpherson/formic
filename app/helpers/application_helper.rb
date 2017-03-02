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
    if score >= 90
      'A*'
    elsif score >= 80
      'A'
    elsif score >= 70
      'B'
    elsif score >= 60
      'C'
    elsif score >= 50
      'D'
    elsif score >= 40
      'E'
    elsif score >= 30
      'F'
    elsif score >= 10
      'U'
    else
      'X'
    end
  end
end
