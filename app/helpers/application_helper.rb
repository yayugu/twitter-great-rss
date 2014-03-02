module ApplicationHelper
  def bookmarklet_escape(js)
    # output_safety string to raw string
    String.new(js)
      .gsub(/^\s+/, '')
      .gsub(/\s+$/, '')
      .gsub("\n", '')
      .gsub('%', '%25')
      .gsub(" ", '%20')
      .gsub('"', '%22')
  end
end
