class Email < ApplicationRecord
  belongs_to :email_type
  belongs_to :extend_demography

  validates_presence_of :email_address, :email_type_id
  validates_uniqueness_of :email_address, scope: [:email_type_id, :extend_demography_id]
  validates_uniqueness_of :email_type_id, scope: [:extend_demography_id]


  def self.safe_attributes
    [:id, :email_type_id, :email_address, :note, :_destroy]
  end

  def to_html
    output = "<div class='col-xs-12'>"
    output<< "<div class='col-xs-2'>#{email_type} </div>"
    output<< "<div class='col-xs-8'>#{email_address} </div>"
    output<< "</div>"
    output
  end

  def email_type
    if email_type_id
      super
    else
      EmailType.default
    end
  end

  def to_pdf(pdf, show_user = true)
    pdf.table([[ "Email type:", " #{email_type} ", "  Email:", " #{email_address}"]], :column_widths => [ 100,150, 100, 173])
  end

end
