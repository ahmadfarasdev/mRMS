class OrganizationEnum < Enumeration
  has_many :core_demographics

  OptionName = :enumeration_organization

  def option_name
    OptionName
  end

  def objects
    CoreDemographic.where(:organization_id => self.id)
  end

  def objects_count
    objects.count
  end

  def transfer_relations(to)
    objects.update_all(:organization_id => to.id)
  end
end