#import "@preview/quick-maths:0.2.1": shorthands
#import "@preview/wrap-it:0.1.1": wrap-content

// Crop the official asset to its graphic mark, without the bilingual wordmark.
#let lab-logo = box(width: 26.4mm, height: 8.976mm, clip: true,
  place(top + left, image("assets/shlab-logo.png", width: 26.4mm, height: 15.3216mm)),
)

#let template(body) = {
  set text(font: ("Noto Sans", "Noto Sans CJK SC"))
  set page(
    margin: 18mm,
    numbering: "1",
    number-align: right + bottom,
  )
  show heading.where(level: 1): set text(fill: rgb("#003B80"))
  show: shorthands.with(
    // Typst already parses => as ⇒; use a string to avoid a self-matching rule.
    ("=>", $⇒$),
    ($<=$, $⇐$),
    ($|>$, $▷$),
    ($<|$, $◁$),
    ($~>$, $arrow.r.long.squiggly$),
    ($<~$, $arrow.l.long.squiggly$),
  )
  wrap-content(
    move(dx: 10mm, dy: -10mm, lab-logo),
    body,
    align: top + right,
    columns: (1fr, 26.4mm),
    column-gutter: 4mm,
  )
}
