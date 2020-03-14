# frozen_string_literal: true

require "spec_helper"

describe "Verification process", type: :system do

  before do
    ::Decidim::ParticpatoryProcessUserRole
    switch_to_host(proposals_component.organization.host)
  end

  def fill_the_verification_form_for_dummy_authorization_handler
    within("#new_verify_wo_registration_") do
      fill_in "verify_wo_registration[authorizations[0]][document_number]", with: "00000000X"
      # fill_in "Postal code", with: ""
      fill_in "verify_wo_registration[authorizations[0]][birthday]", with: "2000/01/01"
      click_button "Verify"
    end
  end

  context "when correctly filling the form" do
    include_examples "has a proposal ready to vote"
    let(:verification_permissions) { create_verification_permissions }

    include_examples "the component has supports_without_registration enabled"

    before do
      go_support_proposal(proposal)
      click_verify_only
      fill_the_verification_form_for_dummy_authorization_handler
    end

    it "redirects to the previous page and renders a notice" do
      expect(page).to have_content("1 PROPOSAL")
    end
  end

end