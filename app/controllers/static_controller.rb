class StaticController < ApplicationController
  skip_before_action :require_login

  def home
  end

  def about
  end

  def features
  end

  def contact
  end
end
