;; extends

((topic_marker) @fold
  (#lua-match? @fold "^@@BEGINTOPIC")
  (#contentdev-help-fold! @fold "topic"))

((tag) @fold
  (#contentdev-help-fold! @fold "tag"))
