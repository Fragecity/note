#import "@preview/quick-maths:0.2.1": shorthands

// Crop the official asset to its graphic mark, without the bilingual wordmark.
#let lab-logo = box(width: 26.4mm, height: 8.976mm, clip: true,
  place(top + left, image("assets/shlab-logo.png", width: 26.4mm, height: 15.3216mm)),
)

#let note(title: none, body) = {
  set document(title: title) if title != none
  set text(font: ("Noto Sans", "Noto Sans CJK SC"))
  set math.equation(numbering: "(1)")
  set page(
    margin: 18mm,
    numbering: "1",
    number-align: right + bottom,
  )
  show heading.where(level: 1): set text(fill: rgb("#003B80"))
  show link: underline
  show: shorthands.with(
    // Typst already parses => as ⇒; use a string to avoid a self-matching rule.
    ("=>", $⇒$),
    ($<=$, $⇐$),
    ($|>$, $▷$),
    ($<|$, $◁$),
    ($~>$, $arrow.r.long.squiggly$),
    ($<~$, $arrow.l.long.squiggly$),
  )
  // Logo lives in the top margin, detached from the text flow, so neither the
  // title nor the body is narrowed or off-center beside it.
  place(top + right, dx: 10mm, dy: -10mm, lab-logo)
  if title != none {
    align(center, block(above: 0pt, below: 1.2em,
      text(size: 22pt, weight: "bold", fill: rgb("#003B80"), title),
    ))
  }
  body
}
