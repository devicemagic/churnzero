module Churnzero
  class Account
    attr_accessor :account_uid, :contact_uid, :attributes

    def initialize(account_uid: nil, contact_uid: nil, **attributes)
      @account_uid = account_uid
      @contact_uid = contact_uid
      @attributes = attributes
    end

    def save
      validate
      data = mapped_attributes.merge({'action' => 'setAttribute',
                                      'entity' => 'account',
                                      'accountExternalId' => account_uid,
                                      'contactExternalId' => contact_uid})
      Client.new.post(data)
    end

    private

      def validate
        errors = []
        ["account_uid", "contact_uid"].each do |attribute|
          errors << attribute if self.send(attribute).nil?
        end
        raise Error.new("You must provide a valid #{errors.join(' & ')}") if errors.any?
      end

      def mapped_attributes
        {
          'attr_Name' => attributes[:name],
          'attr_NextRenewalDate' => attributes[:next_renewal_date],
          'attr_TotalContractAmount' => attributes[:total_contract_amount],
          'attr_IsActive' => attributes[:is_active],
          'attr_BillingAddressLine1' => attributes[:billing_address_line1],
          'attr_BillingAddressLine2' => attributes[:billing_address_line2],
          'attr_BillingAddressCity' => attributes[:billing_address_city],
          'attr_BillingAddressState' => attributes[:billing_address_state],
          'attr_BillingAddressZip' => attributes[:billing_address_zip],
          'attr_StartDate' => attributes[:start_date],
          'attr_EndDate' => attributes[:end_date],
          'attr_LicenseCount' => attributes[:license_count],
          'attr_OwnerUserAccount' => attributes[:owner_user_account],
          'attr_ParentAccountExternalId' => attributes[:parent_account_external_id]
        }.compact
      end

  end
end
