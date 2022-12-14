# frozen_string_literal: true

# Ответ конкретного пользователя
class AddUserIdToAnswers < ActiveRecord::Migration[7.0]
  def change
    add_reference :answers, :user, null: false, foreign_key: true, default: User.first.id
  end
end
