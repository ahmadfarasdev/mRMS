class SocialMedium < ApplicationRecord
  belongs_to :extend_demography, optional: true
  belongs_to :social_media_type

  validates_presence_of :social_media_handle, :social_media_type_id
  validates_uniqueness_of :social_media_type_id, scope: [:extend_demography_id]

  def self.safe_attributes
    [:id, :social_media_type_id, :social_media_handle, :note, :_destroy]
  end

  def to_html
    output = "<div class='col-xs-12'>"
    output<< "<div class='col-xs-2'>#{social_media_type} </div>"
    output<< "<div class='col-xs-8'>#{social_media_handle} </div>"
    output<< "</div>"
    output.html_safe
  end

  def social_media_type
    if social_media_type_id
      super
    else
      SocialMediaType.default
    end
  end

  def to_pdf(pdf, show_user = true)
    pdf.move_down 10
    pdf.table([[ "Social media type:", " #{social_media_type}", " #:", " #{social_media_handle}"]], :column_widths => [ 100,150, 100, 173])
  end

end
