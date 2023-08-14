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