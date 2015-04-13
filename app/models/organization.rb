class Organization < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  has_and_belongs_to_many :projects
  has_many :questions
  has_one :user, :as => :rolable

  attr_accessible :description, :name, :website, :sname, :organization_id
  
  def self.sname_hash_to_org_list(org_params)
    org_params.select { |k, v| v == '1' }.keys.map { |sname|
      Organization.find_by_sname(sname)
    }.select { |org| org != nil }
  end
end
