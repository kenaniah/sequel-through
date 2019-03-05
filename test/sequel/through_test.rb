require "test_helper"

describe "Sequel::Plugins::ThroughAssociations" do

  before do
    class ::User < Sequel::Model
      plugin :through_associations
      one_to_many :user_has_security_groups
    end
    class ::SecurityGroup < Sequel::Model
      plugin :through_associations
      one_to_many :security_group_has_privileges
    end
    class ::Privilege < Sequel::Model
      plugin :through_associations
    end
    class ::UserHasSecurityGroup < Sequel::Model
      plugin :through_associations
      many_to_one :user
      many_to_one :security_group
    end
    class ::SecurityGroupHasPrivilege < Sequel::Model
      plugin :through_associations
      many_to_one :security_group
      many_to_one :privilege
    end
  end
  after do
    Object.send :remove_const, :User
    Object.send :remove_const, :SecurityGroup
    Object.send :remove_const, :UserHasSecurityGroup
    Object.send :remove_const, :Privilege
    Object.send :remove_const, :SecurityGroupHasPrivilege
  end

  it "should create through associations recursively" do

    User.one_to_many :security_groups, through: :user_has_security_groups
    SecurityGroup.one_to_many :privileges, through: :security_group_has_privileges
    UserHasSecurityGroup.one_to_many :privileges, through: :security_group
    User.one_to_many :privileges, through: :security_groups

    # One to many
    assert_equal :many_through_many, User.association_reflection(:security_groups)[:type]
    assert_equal :many_through_many, SecurityGroup.association_reflection(:privileges)[:type]
    assert_equal :many_through_many, UserHasSecurityGroup.association_reflection(:privileges)[:type]
    assert_equal :many_through_many, User.association_reflection(:privileges)[:type]

    # Many to many
    User.many_to_many :privileges, through: :security_groups
    assert_equal :many_through_many, User.association_reflection(:privileges)[:type]

    # Many to one
    User.many_to_one :privilege, through: :security_groups
    assert_equal :one_through_many, User.association_reflection(:privilege)[:type]

    # One to one
    User.one_to_one :privilege, through: :security_groups
    assert_equal :one_through_many, User.association_reflection(:privilege)[:type]

    # Normal associations
    assert_equal :one_to_many, User.association_reflection(:user_has_security_groups)[:type]
    assert_equal :many_to_one, UserHasSecurityGroup.association_reflection(:user)[:type]

  end

  it "should call #associate_through when creating associations that are based on others" do
    skip
  end

end
