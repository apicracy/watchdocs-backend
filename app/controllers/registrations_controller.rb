class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)

    resource.save &&
      ActiveCampaignTracking.for(resource.email)
                            .add_to_contacts
    yield resource if block_given?
    render_resource(resource)
  end
end
