// Unified entrypoint for notes and presentations.
#import "note.typ": note
#import "pre.typ": pre, slides, title-slide, overview-slide, slide, new-section-slide, focus-slide, matrix-slide

// Keep the original note function name available during migration.
#let template = note
