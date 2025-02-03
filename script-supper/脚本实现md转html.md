# 脚本是如何实现Markdown转html？（简述与附加支持MD）
1) 引入文件
```
// @require      https://cdn.jsdelivr.net/npm/showdown@1.9.0/dist/showdown.min.js
// @resource markdown-css https://sindresorhus.com/github-markdown-css/github-markdown.css

// @require      https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/highlight.min.js
// @resource code-css https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/styles/default.min.css
```

2）css文件加载
```js
// @grant        GM_addStyle
// @grant        GM_getResourceText
... 
GM_addStyle(GM_getResourceText("code-css"));
GM_addStyle(GM_getResourceText("markdown-css"));
```
3)开始使用
```js

converter.makeHtml(htmlStr)  -> 使用showdown.min.js
在markdown存放的html容器标签上加class “markdown-body” -> 使用github-markdown.css
// 使用highlight.min.js与使用highlight的default.min.css
document.querySelectorAll('#text_show pre code').forEach((el) => {
    hljs.highlightElement(el);
});

```

## marked方式
还有一种，使用marked代替showdown
html案例:
```html
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Markdown 转 HTML</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/marked/9.0.2/marked.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const markdownContent = `
\`\`\`js
console.log("hello world");
\`\`\`
            `;
            document.getElementById("content").innerHTML = marked.parse(markdownContent);
            document.querySelectorAll("pre code").forEach((block) => {
                hljs.highlightElement(block);
            });
        });
    </script>
</head>
<body>
    <h2>Markdown 渲染示例</h2>
    <div id="content"></div>
</body>
</html>

```