# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.destroy_all
Profile.destroy_all
TodoList.destroy_all
TodoItem.destroy_all

User.create! [
  { username: "Fiorina", password_digest: "1954" }, 
  { username: "Trump"  , password_digest: "1946" }, 
  { username: "Carson" , password_digest: "1951" }, 
  { username: "Clinton", password_digest: "1947" }
]

User.find_by!(username: "Fiorina").create_profile( first_name: "Carly", last_name: "Fiorina", birth_year: 1954, gender: "female" )
User.find_by!(username: "Fiorina").todo_lists.create!( list_name: "todolist1", list_due_date: Date.today + 1.day)

User.find_by!(username: "Trump").create_profile( first_name: "Donald", last_name: "Trump", birth_year: 1946, gender: "male" )
User.find_by!(username: "Trump").todo_lists.create!( list_name: "todolist2", list_due_date: Date.today + 2.day)

User.find_by!(username: "Carson").create_profile( first_name: "Ben", last_name: "Carson", birth_year: 1951, gender: "male" )
User.find_by!(username: "Carson").todo_lists.create!( list_name: "todolist3", list_due_date: Date.today + 3.day)

User.find_by!(username: "Clinton").create_profile( first_name: "Hillary", last_name: "Clinton", birth_year: 1947  , gender: "female" )
User.find_by!(username: "Clinton").todo_lists.create!( list_name: "todolist4", list_due_date: Date.today + 4.day)

CHOSEN_TIME = Time.now + 1.year 

User.all.each do |user| 
  todo_list = TodoList.find_by!(user_id: user.id)
  for i in 1..5
    todo_list.todo_items.create!(title: "#{todo_list.list_name}-item#{i}", due_date: CHOSEN_TIME, description: "desc#{i}")
  end
end