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
        default = {
          'attr_Name' => attributes.delete(:name),
          'attr_NextRenewalDate' => attributes.delete(:next_renewal_date),
          'attr_TotalContractAmount' => attributes.delete(:total_contract_amount),
          'attr_IsActive' => attributes.delete(:is_active),
          'attr_BillingAddressLine1' => attributes.delete(:billing_address_line1),
          'attr_BillingAddressLine2' => attributes.delete(:billing_address_line2),
          'attr_BillingAddressCity' => attributes.delete(:billing_address_city),
          'attr_BillingAddressState' => attributes.delete(:billing_address_state),
          'attr_BillingAddressZip' => attributes.delete(:billing_address_zip),
          'attr_StartDate' => attributes.delete(:start_date),
          'attr_EndDate' => attributes.delete(:end_date),
          'attr_LicenseCount' => attributes.delete(:license_count),
          'attr_OwnerUserAccount' => attributes.delete(:owner_user_account),
          'attr_ParentAccountExternalId' => attributes.delete(:parent_account_external_id)
        }.compact

        # Note custom attributes are coverted to start case
        # example :message_count will become "Message Count"
        custom = {}
        attributes.each do |key, value|
          key = key.to_s.split("_").map(&:capitalize).join(" ")
          key = "attr_#{key}"
          custom[key] = value
        end
        custom = custom.compact

        # Note default attributes takes precedence
        custom.merge(default)
      end

  end
end
