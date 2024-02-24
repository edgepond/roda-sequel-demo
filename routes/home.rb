# frozen_string_literal: true
class RodaDemo
  hash_branch('home') do |r|
		rodauth.require_authentication
    view 'index'
  end
end
