require 'csv'

class UsersCsvGenerator
  def initialize(users)
    @users = users
  end

  def run
    attributes = %w{id email first_name last_name groups roles}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      @users.each do |user|
        row = attributes.map{ |attr| user.send(attr) if user.attribute_names.include?(attr) }
        row << user.groups.map(&:name).sort.join(',')
        row << user.roles.map(&:name).sort.join(',')
        csv << row.flatten
      end
    end
  end
end
