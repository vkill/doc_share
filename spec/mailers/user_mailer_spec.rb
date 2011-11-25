require "spec_helper"

describe UserMailer do
  describe "reset_password_email" do
    let(:mail) { UserMailer.reset_password_email }

    it "renders the headers" do
#      mail.subject.should eq("Reset password email")
    end

    it "renders the body" do
#      mail.body.encoded.should match("Hi")
    end
  end

  describe "activation_needed_email" do
    let(:mail) { UserMailer.activation_needed_email }

    it "renders the headers" do
    end

    it "renders the body" do
    end
  end

  describe "activation_success_email" do
    let(:mail) { UserMailer.activation_success_email }

    it "renders the headers" do
    end

    it "renders the body" do
    end
  end

end

