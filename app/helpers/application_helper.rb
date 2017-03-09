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

  def notify(user, title, message, link)
    user.notifications.create(title: title, message: message, link: link)
  end

  def score_to_grade(score)
    if score >= 1.5
      'Platinum'
    elsif score >= 0.5
      'Gold'
    elsif score >= -0.5
      'Green'
    elsif score >= -1.5
      'Yellow'
    else
      'Red'
    end
  end

  def pretty_count(count)
    count > 9 ? '9+' : count
  end

  # Method only called if @user exists
  def related_user_type(type)
    case @user.group
      when 1
        if type == 'Teacher'
          'Tutor'
        else
          type
        end
      when 2
        if type == 'Student'
          'Child'
        elsif type == 'Teacher'
          'Tutor of Child'
        else
          type
        end
      when 3
        if type == 'Student'
          'Tutee'
        else
          type
        end
      else
        type
    end
  end
end
