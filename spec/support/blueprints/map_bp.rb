require 'machinist'
require 'models/kb_map'

class Object
  extend Machinist::Machinable

  def self.blueprint_class
    Machinist::Blueprint
  end
end


KBMap.blueprint do
  testVar { 'some blueprinted value' }
end
