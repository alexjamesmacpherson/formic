require 'test_helper'

class TermTest < ActiveSupport::TestCase
  def setup
    @school = schools(:test_college)
    @term = @school.terms.build(name: 'Term X', starts: Time.zone.now, ends: Time.zone.now + 1.week, halfterm_starts: Time.zone.now + 2.days, halfterm_ends: Time.zone.now + 4.days)
  end

  test 'term is valid and can be saved' do
    assert @term.valid?
    assert @term.save
  end

  test 'term must belong to school' do
    @term.school = nil
    assert_not @term.valid?
  end

  test 'term cannot belong to non-existent school' do
    assert School.exists?(@term.school_id)
    assert_not School.exists?(10)

    @term.school_id = 10
    assert_not @term.valid?
  end

  test 'term has name of valid length' do
    invalid_names = ['', 'a' * 256]
    invalid_names.each do |invalid|
      @term.name = invalid
      assert_not @term.valid?, "#{invalid.inspect} should not be a valid term name"
    end

    @term.name = 'a' * 50
    assert @term.valid?
  end

  test 'term must have start date' do
    @term.starts = nil
    assert_not @term.valid?
  end

  test 'term must have end date' do
    @term.ends = nil
    assert_not @term.valid?
  end

  test 'term must start before it finishes' do
    @term.starts = @term.ends + 1.day
    assert_not @term.valid?
  end

  test 'term must have half term start date' do
    @term.halfterm_starts = nil
    assert_not @term.valid?
  end

  test 'term must have half term end date' do
    @term.halfterm_ends = nil
    assert_not @term.valid?
  end

  test 'half term must start before it finishes' do
    @term.halfterm_starts = @term.halfterm_ends + 1.day
    assert_not @term.valid?
  end

  test 'can ascertain whether a date is during term or not' do
    assert @term.in_term?(Time.zone.now + 4.days)
    assert_not @term.in_term?(Time.zone.now - 4.days)
  end

  test 'term must contain half term' do
    @term.halfterm_starts = @term.starts - 1.day
    assert_not @term.valid?

    @term.halfterm_ends = @term.ends + 1.day
    assert_not @term.valid?

    @term.halfterm_starts = @term.starts + 1.day
    assert_not @term.valid?
  end

  test 'can ascertain whether a date is during half term or not' do
    assert @term.in_halfterm?(Time.zone.now + 3.days)
    assert_not @term.in_halfterm?(Time.zone.now + 1.day)
  end
end
