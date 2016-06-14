require "rails_helper"

describe ContributorsController do
  describe "#index" do
    it "detects the repository from the path" do
      fake_client = double.as_null_object
      allow(Repo).to receive(:new).and_return(double.as_null_object)
      allow(Octokit::Client).to receive(:new).and_return(fake_client)
      params = { organization: "graysonwright", repo_name: "osbot" }

      get :index, params: params, session: stubbed_user_session

      expect(Repo).to have_received(:new).with(
        "graysonwright/osbot",
        fake_client,
      )
    end
  end

  def stubbed_user_session
    { user: {
      token: "0123456789abcdef",
      handle: "graysonwright",
      image_url: "http://placekitten.com/200/300",
    } }
  end
end
