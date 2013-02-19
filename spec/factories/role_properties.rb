# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role_property, :class => 'RoleProperties' do
    rolename "MyString"
    property "MyString"
    value "MyString"
  end
end
