require "rails_helper"

describe ContributorsController do
  describe "#index" do
    it "detects the repository from the path" do
      allow(Repo).to receive(:new).and_return(double.as_null_object)

      get :index, params: { organization: "graysonwright", repo_name: "osbot" }

      expect(Repo).to have_received(:new).with("graysonwright/osbot")
    end
  end
end
