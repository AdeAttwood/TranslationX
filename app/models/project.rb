# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :user
  belongs_to :primary_language, class_name: Language.name
  has_and_belongs_to_many :languages
  has_many :translations

  validates :name, presence: true
  validates :primary_language, presence: true
end
