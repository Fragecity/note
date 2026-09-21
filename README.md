# note

个人 Typst 笔记模板：中文字体、深蓝色一级标题、18mm 页边距、右下角页码，以及仅首页显示的上海人工智能实验室图形标志（文字环绕）。

## 使用

将仓库放在 Typst 本地包目录 `packages/local/note/0.1.0` 下。Linux 的默认位置为 `~/.local/share/typst/packages/local/note/0.1.0`。

```typ
#import "@local/note:0.1.0": template
#show: template.with(title: [笔记标题])

= 一级标题
中文正文。English text.
```

`title` 可使用字符串或内容块，设置首页标题和 PDF 文档标题。不需要标题时，仍可使用 `#show: template`。

需要字体 `Noto Sans` 和 `Noto Sans CJK SC`。首次编译需要下载 `quick-maths:0.2.1` 和 `wrap-it:0.1.1`。

## 示例

```sh
typst compile template/main.typ example.pdf
```

Logo 原始素材及来源见 `assets/README.md`。
