module ApplicationHelper
  def markdown(text)
    markdown_renderer.render(text).html_safe
  end

  def markdown_renderer
    @markdown_renderer if defined? @markdown_renderer

    @markdown_renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new({}), {})
  end
end
