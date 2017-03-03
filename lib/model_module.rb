module ModelModule
  def school_exists?(id)
    unless School.exists?(id)
      errors.add(:school, 'must exist')
    end
  end

  def year_group_exists?(id)
    if is_student? && !YearGroup.exists?(id)
      errors.add(:year_group, 'must exist')
    end
  end
end