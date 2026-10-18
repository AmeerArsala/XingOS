-- /clip: one result that opens Noctalia's clipboard history panel.
function onQuery(text)
  launcher.setResults(text, {
    { id = "open", title = "Clipboard history", subtitle = "Press Enter to open", glyph = "clipboard", score = 100 },
  })
end

function onActivate(id)
  noctalia.runAsync("noctalia msg panel-toggle clipboard")
end
