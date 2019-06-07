require "test_helper"

describe 'ThroughAssociations#associate' do

  it 'should not conflict with :dataset_associations' do

    # Create two models
    uhg = Sequel::Model :user_has_groups
    users = Sequel::Model :users

    # Add plugins in an order that would conflict if #associate was not prepended
    users.plugin :cyclical_through_associations
    users.plugin :dataset_associations

    # Add an association that exists
    refute_nil users.one_to_many :user_has_groups, class: uhg

    # Add an association that can not be resolved yet
    assert_nil users.many_to_many :groups, through: :user_has_groups

  end

  it 'should raise if creating an invalid assocation using :through_associations' do

    # Create two models
    uhg = Sequel::Model :user_has_groups
    users = Sequel::Model :users

    # Add plugins in an order that would conflict if #associate was not prepended
    users.plugin :through_associations

    # Add an association that exists
    refute_nil users.one_to_many :user_has_groups, class: uhg

    # Add one that does not exist
    assert_raises Sequel::Plugins::ThroughAssociations::MissingAssociation do
      users.many_to_many :groups, through: :user_has_groups
    end

  end

  it 'should queue if creating an invalid association using :cyclical_through_associations' do

    # Create three models
    uhg = Sequel::Model :user_has_groups
    users = Sequel::Model :users
    groups = Sequel::Model :groups

    users.plugin :cyclical_through_associations

    # Add an association that exists
    refute_nil users.one_to_many :user_has_groups, class: uhg

    # Add an association that is currently invalid
    assert_nil users.one_to_many :groups, through: :user_has_groups

    # Attempting to resolve the groups association should currently fail
    assert_raises Sequel::Plugins::ThroughAssociations::MissingAssociation do
      users.solve_cyclical_associations!
    end
    assert_nil users.association_reflection :groups

    # Add the missing association
    refute_nil uhg.many_to_one :user, class: users
    refute_nil uhg.many_to_one :group, class: groups

    puts uhg.association_reflection(:group).inspect

    # Attempt to resovle again
    users.solve_cyclical_associations!

    # The assoication should now exist
    refute_nil users.association_reflection :groups

  end

end
