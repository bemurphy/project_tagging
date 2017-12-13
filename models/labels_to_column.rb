class LabelsToColumn
  MAPPING_ORDER = {
    "in progress" => "In Progress",
    "review"      => "Ready for Review",
    "thumbsup"    => "Ready to Land"
  }

  def initialize(project_id, labels)
    @project_id = project_id
    @labels     = labels
  end

  def column
    key = (MAPPING_ORDER.keys & label_names).last

    if column_name = MAPPING_ORDER[key]
      GithubProjectColumns.project_column_by_name(@project_id, column_name)
    end
  end

  def label_names
    @labels.map(&:name)
  end
end
