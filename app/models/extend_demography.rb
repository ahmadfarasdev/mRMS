class ExtendDemography < ApplicationRecord

  has_many :emails, foreign_key: :extend_demography_id
  accepts_nested_attributes_for :emails, reject_if: :all_blank, allow_destroy: true

  has_many :faxes, foreign_key: :extend_demography_id
  accepts_nested_attributes_for :faxes, reject_if: :all_blank, allow_destroy: true
  has_many :addresses, foreign_key: :extend_demography_id
  accepts_nested_attributes_for :addresses, reject_if: :all_blank, allow_destroy: true

  has_many :phones, foreign_key: :extend_demography_id
  accepts_nested_attributes_for :phones, reject_if: :all_blank, allow_destroy: true
  has_many :identifications, foreign_key: :extend_demography_id
  accepts_nested_attributes_for :identifications, reject_if: :all_blank, allow_destroy: true

  has_many :social_media, foreign_key: :extend_demography_id
  accepts_nested_attributes_for :social_media, reject_if: :all_blank, allow_destroy: true

  belongs_to :user


  def object
  end

  def default_address
    addresses.first || Address.new
  end

  def default_phone
    phones.first || Phone.new
  end

  def has_informations?
    emails.present? or faxes.present? or phones.present? or identifications.present? or social_media.present? or addresses.present?
  end

  def self.safe_attributes
    [:user_id, :department_id, :type, :contact_id, :organization_id, :affiliation_id, :insurance_id, :case_support_id,
     social_media_attributes: [SocialMedium.safe_attributes],
     emails_attributes: [Email.safe_attributes],
     addresses_attributes: [Address.safe_attributes],
     faxes_attributes:   [Fax.safe_attributes],
     phones_attributes: [Phone.safe_attributes],
     identifications_attributes:   [Identification.safe_attributes]]
  end
end
