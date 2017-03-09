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

  def challenge_grades_for(user, subject)
    red = 0
    yellow = 0
    green = 0
    gold = 0
    platinum = 0
    count = 0

    submissions = user.submissions.where(marked: true)
    submissions.each do |submission|
      if submission.assignment.subject == subject
        score = submission.grade
        if score >= 1.5
          platinum += 1
        elsif score >= 0.5
          gold += 1
        elsif score >= -0.5
          green += 1
        elsif score >= -1.5
          yellow += 1
        else
          red += 1
        end
        count += 1
      end
    end

    if count > 0
      "<div class=\"avatar tip\">#{pie_chart [["Red", red], ["Yellow", yellow], ["Green", green], ["Gold", gold], ["Platinum", platinum]], legend: false, id: 'avatar-chart', colors: ['#ee1d23', '#fec63f', '#8bc63e', '#c3b49b', '#d1d2d4']}<span class=\"tip-text\" style=\"background: rgba(25,25,25,0.95); width: 250px;\">Your challenge grade attainment indicator gives an overview of your performance in #{subject.name}, offering a snapshot as to how well you are progressing in your studies against your assigned challenge grade.</span></div>"
    end
  end

  def avatar_of(user)
    if user.is?(:group, 1)
      red = 0
      yellow = 0
      green = 0
      gold = 0
      platinum = 0
      total = 0

      user.studies.each do |subject|
        score = 0
        count = 0
        submissions = user.submissions.where(marked: true)
        submissions.each do |submission|
          if submission.assignment.subject == subject
            score = score + submission.grade
            count += 1
          end
        end
        if count > 0
          score = score / count

          if score >= 1.5
            platinum += 1
          elsif score >= 0.5
            gold += 1
          elsif score >= -0.5
            green += 1
          elsif score >= -1.5
            yellow += 1
          else
            red += 1
          end

          total += 1
        end
      end

      if total > 0
        "<div class=\"avatar tip\">#{pie_chart [["Red", red], ["Yellow", yellow], ["Green", green], ["Gold", gold], ["Platinum", platinum]], donut: true, legend: false, id: 'avatar-chart', colors: ['#ee1d23', '#fec63f', '#8bc63e', '#c3b49b', '#d1d2d4']}#{image_tag(user.avatar.url, class: 'avatar')}<span class=\"tip-text\" style=\"background: rgba(25,25,25,0.95); width: 250px;\">Your challenge grade attainment indicator gives an overview of your performance across all your modules, offering a snapshot as to how well you are progressing in your studies.</span></div>"
      else
        image_tag(user.avatar.url, class: 'avatar')
      end
    else
      image_tag(user.avatar.url, class: 'avatar')
    end

  end
end
