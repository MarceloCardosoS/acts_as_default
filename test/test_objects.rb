class Parent < ActiveRecord::Base
  include ActsAsDefault
  acts_as_default

  has_many :sons
end

class Son < ActiveRecord::Base
  include ActsAsDefault
  acts_as_default :parent_id

  belongs_to :parent
end

def setup_objects
  ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database => ':memory:'
  )

  ActiveRecord::Schema.define do
    self.verbose = false

    create_table :parents, :force => true do |t|
      t.timestamps
      t.boolean :default
    end

    create_table :sons, :force => true do |t|
      t.belongs_to :parent
      t.boolean :default
      t.timestamps
    end
  end
end