class ChangeDueDateColumn < ActiveRecord::Migration
  def change
    change_column :todo_lists, :list_due_date, :date
  end
end
