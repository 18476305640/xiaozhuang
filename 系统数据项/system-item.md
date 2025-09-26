# [系统项]使用说明（了解新功能）
1、基本使用：ctrl+alt+s呼出  Esc 隐藏
2、数据项组成：简单链接|简述文本、附加内容、快捷链接(links|主项的相关链接)
3、子搜索模式：<搜索数据项><tab><子项接收文本> ， 取消子搜索模式`shift+tab`
    3.1、呼出搜索框直接按`tab`键，输入问题再回车即可体现AI简单问答功能。
4、按搜索框的右边“徽|LOGO”，查看系统项
5、`Ctrl+回车` 相关于点击查看"附加内容"并有关键词标注定位。

[官方Github Wiki](https://github.com/My-Search)  |  [更新日志](https://github.com/My-Search/my-search/blob/master/%E6%9B%B4%E6%96%B0%E6%97%A5%E5%BF%97.md)


# [系统项] 关于脚本（作者 & 脚本）
> 由于热爱收集各类软件和网站，因此积累了大量的信息。之前我常常通过文字搜索（`Ctrl+F `）在记录中找到所需信息。然而，这种方式并不总是高效而直观。因此，我开发了这款脚本，它可以帮助我更快地检索和导航到我需要的信息。通过这款脚本，我能够更有效地管理并使用我的收集的所有资源。

[更新日志](https://github.com/My-Search/my-search/blob/master/%E6%9B%B4%E6%96%B0%E6%97%A5%E5%BF%97.md) | [意见反馈/内容提交](https://github.com/18476305640/xiaozhuang/issues/new) 
**作者**：Zhuang Jie
**邮箱**：2119299531@qq.com
**致谢**：
- [实现MD转HTML](https://github.com/18476305640/xiaozhuang/blob/dev/script-supper/%E8%84%9A%E6%9C%AC%E5%AE%9E%E7%8E%B0md%E8%BD%AChtml.md)

**其它**：
- [公益Clash订阅](clash://install-config?url=https%3A%2F%2Fsub2.smallstrawberry.com%2Fapi%2Fv1%2Fclient%2Fsubscribe%3Ftoken%3D2bfb524a3b4e4c9b861e3054746a9d21)

# [h'脚本'][系统项]新数据项（订阅作者新添加的项）
-- env --
_icon data:image/svg+xml;base64,PHN2ZyB2ZXJzaW9uPSIxLjIiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgdmlld0JveD0iMCAwIDY0IDY0IiB3aWR0aD0iNjQiIGhlaWdodD0iNjQiPgoJPHRpdGxlPuaWsOW7uumhueebrjwvdGl0bGU+Cgk8c3R5bGU+CgkJLnMwIHsgZmlsbDogI2ZmMDAwMCB9IAoJCS5zMSB7IG9wYWNpdHk6IC42O2ZpbGw6ICNmZjAwMDAgfSAKCQkuczIgeyBvcGFjaXR5OiAuNDtmaWxsOiAjZmYwMDAwIH0gCgk8L3N0eWxlPgoJPHBhdGggaWQ9IuW9oueKtiAxIiBjbGFzcz0iczAiIGQ9Im00LjggMTQuMWg1NC4ydjYuOGgtNTQuMnoiLz4KCTxwYXRoIGlkPSLlvaLnirYgMyIgY2xhc3M9InMxIiBkPSJtNSAyOC4xaDU0djYuOGgtNTR6Ii8+Cgk8cGF0aCBpZD0i5b2i54q2IDQiIGNsYXNzPSJzMiIgZD0ibTUgNDIuMWg1NHY2LjhoLTU0eiIvPgoJPHBhdGggaWQ9IuW9oueKtiAyIiBjbGFzcz0iczAiIGQ9Im0zMiAzMnoiLz4KPC9zdmc+
-- script -- 
function ( {registry} ) {
  registry.searchData.triggerSearchHandle(registry.searchData.specialKeyword.new); 
}

# [h'脚本']历史记录（最近查看的项）
-- env --

-- script -- 
function ( {registry} ) {
  registry.searchData.triggerSearchHandle(registry.searchData.specialKeyword.history); 
}
# [h'脚本'] 我的HOT（脚本使用者经常选择的项）
-- env --

-- script -- 
function ( {registry} ) {
  registry.searchData.triggerSearchHandle(registry.searchData.specialKeyword.highFrequency); 
}