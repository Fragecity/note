#import "themes/university.typ": *

// Personal defaults; each item can be overridden with pre.with(...).
#let pre(
  title: [演示标题],
  subtitle: none,
  kicker: none,
  author: [Bian Kaiming],
  advisor: [Fu Rong],
  date: none,
  institution: none,
  logo-left: image("assets/SUSTech LOGO CN.svg", height: 1.55cm),
  logo-right: image("assets/shanghai-ai-lab.webp", height: 1.25cm),
  aspect-ratio: "16-9",
  progress-bar: true,
  outline-depth: 1,
  body,
) = {
  show: university-theme.with(
    aspect-ratio: aspect-ratio,
    progress-bar: progress-bar,
    config-info(
      title: title,
      subtitle: subtitle,
      kicker: kicker,
      author: [
        #text(weight: "semibold", fill: c-ink, author)
        #if advisor != none {
          h(14pt)
          text(fill: c-dim)[|]
          h(14pt)
          text(fill: c-muted)[导师：#advisor]
        }
      ],
      date: date,
      institution: institution,
      logo-left: logo-left,
      logo-right: logo-right,
    ),
    header-right: self => none,
  )
  show footnote.entry: set text(size: 11.5pt)
  set outline(depth: outline-depth)
  body
}

#let slides = pre

// Clean minimal overview slide (no background card fill, title-only items).
#let overview-slide(title: [Overview], depth: 1) = {
  heading(depth: 2, outlined: false, title)
  v(1fr)
  context {
    let sections = query(heading.where(level: 1))
    let cols = if sections.len() <= 3 { (1fr,) } else { (1fr, 1fr) }
    grid(
      columns: cols,
      column-gutter: 42pt,
      row-gutter: 32pt,
      ..sections.enumerate().map(((i, sec)) => {
        link(sec.location(), block(
          width: 100%,
          fill: none,
          stroke: none,
          inset: (x: 4pt, y: 6pt),
          grid(
            columns: (42pt, 1fr),
            column-gutter: 12pt,
            align: (left + horizon, left + horizon),
            text(
              size: 24pt,
              weight: "bold",
              fill: c-teal.desaturate(20%).transparentize(32%),
              pad-two(i + 1),
            ),
            text(size: 19pt, weight: "bold", fill: c-ink, sec.body),
          ),
        ))
      })
    )
  }
  v(1.2fr)
}
