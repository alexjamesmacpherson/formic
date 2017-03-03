class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def id_but_nonexistent?(id)
      id && !self.exists?(id)
    end
  end

  def school_exists?
    unless School.exists?(school_id)
      errors.add(:school, 'must exist')
    end
  end

  def subject_exists?
    unless Subject.exists?(subject_id)
      errors.add(:subject, 'must exist')
    end
  end

  def period_exists?
    unless Period.exists?(period_id)
      errors.add(:period, 'must exist')
    end
  end

  def department_exists?
    unless Department.exists?(department_id)
      errors.add(:department, 'must exist')
    end
  end

  def user_is_correct_if_real?(attr, id, group)
    if User.id_but_nonexistent?(id)
      errors.add(attr, 'must exist')
    elsif User.exists_but_not_group?(id, group)
      errors.add(attr, 'must have correct user group')
    end
  end

  def user_is_correct_and_real?(attr, id, group)
    if !User.exists?(id)
      errors.add(attr, 'must exist')
    elsif User.exists_but_not_group?(id, group)
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
