# frozen_string_literal: true

# Хелпер вью пользователя
class UserDecorator < ApplicationDecorator
  delegate_all

  def name_or_email
    return name if name.present?

    email.split('@')[0]
  end
end
