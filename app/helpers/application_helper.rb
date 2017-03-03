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

  def notify(user, message, link)
    user.notifications.create(message: message, link: link)
  end

  def score_to_grade(score)
    if score == 100
      'A*'
    elsif score < 10
      'X'
    elsif score < 30
      'U'
    else
      grades = ['F', 'E', 'D', 'C', 'B' ,'A' ,'A*']
      ix = (score / 10).floor - 3
      grades[ix]
    end
  end
end
