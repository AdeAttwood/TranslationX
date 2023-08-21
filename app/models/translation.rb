# frozen_string_literal: true

class Translation < ApplicationRecord
  belongs_to :language
  belongs_to :project

  validates :key, presence: true
  validates :value, presence: true
  validates :language, presence: true
  validates :project, presence: true

  paginates_per 25
end
