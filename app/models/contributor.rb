class Contributor
  include ActiveModel::Model

  attr_accessor :handle
  attr_writer :pulls, :issues, :pull_comments, :comments
  attr_accessor :collaborator_info

  def score
    1_000_000 * (
      10 * score_for_contributions(pulls) +
      5 * score_for_contributions(issues) +
      3 * score_for_contributions(pull_comments) +
      1 * score_for_contributions(comments)
    )
  end

  def admin_permissions?
    fetch_permission(:admin, false)
  end

  def push_permissions?
    fetch_permission(:push, false)
  end

  def pull_permissions?
    fetch_permission(:pull, true)
  end

  def pulls
    @pulls || []
  end

  def issues
    @issues || []
  end

  def pull_comments
    @pull_comments || []
  end

  def comments
    @comments || []
  end

  private

  def fetch_permission(permission_name, fallback)
    if collaborator_info.present?
      collaborator_info.attrs[:permissions].attrs[permission_name]
    else
      fallback
    end
  end

  def score_for_contributions(contribution_collection)
    contribution_collection.sum do |contribution|
      time_since_contribution = Time.current - contribution.attrs[:created_at]
      1.0 / time_since_contribution
    end
  end
end
