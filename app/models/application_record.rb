class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def is_record?(attr, model, id)
    if id && !model.exists?(id)
      errors.add(attr, 'must exist')
    end
  end

  def school_exists?
    is_record?(:school, School, school_id)
  end

  def subject_exists?
    is_record?(:subject, Subject, subject_id)
  end

  def period_exists?
    is_record?(:period, Period, period_id)
  end

  def department_exists?
    is_record?(:department, Department, department_id)
  end

  def year_group_exists?
    is_record?(:year_group, YearGroup, year_group_id)
  end

  def user_is_correct_if_real?(attr, id, group)
    is_record?(:attr, User, id)

    if User.exists_but_not_group?(id, group)
      errors.add(attr, 'must have correct user group')
    end
  end

  def grade_percentage?(attr, grade)
    if grade && !(0..100).include?(grade)
      errors.add(attr, 'must be a percentage between 0-100%')
    end
  end

  def ends_before_start?(attr, starts, ends)
    return unless starts && ends

    if starts > ends
      errors.add(attr, 'cannot be before start')
    end
  end
end
