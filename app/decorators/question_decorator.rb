# frozen_string_literal: true

# Хелпер вью вопроса
class QuestionDecorator < ApplicationDecorator
  delegate_all

  def formatted_created_at
    created_at.strftime('%d.%m.%Y %H:%M:%S')
  end
end
