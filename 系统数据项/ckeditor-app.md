# [h'script']CKEditor-本地编辑器（本地存储编辑器）
-- env --
_icon data:image/svg+xml;base64,PHN2ZyB0PSIxNzM1NDA0MzA1MzE1IiBjbGFzcz0iaWNvbiIgdmlld0JveD0iMCAwIDEwODEgMTAyNCIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHAtaWQ9IjUxMTMiIHdpZHRoPSIyMDAiIGhlaWdodD0iMjAwIj48cGF0aCBkPSJNOTc3LjIwNyA0ODguNjA1Yy0yMC4xMjYgMC0zMC42NDQgMi42MTYtNTkuMjQyIDMzLjE0Ni01MS44NSA1NS40MzMtMTcyLjk1IDE4My41ODItMjUxLjEyNCAyNjEuNzU2LTE0OS4zNTUgMTQ5LjM1Ni0yNTkuMzY4IDE5NC4yNy0zNzYuNjAxIDY2LjM0OS03MC44NC03Ny4zMjEtMzguMzc3LTE4Ni44MjIgMC0yMjUuMDI4QzQxNy40MjIgNDk4LjA0MyA2MzUuNCAyNzguMzAyIDY4Ny42NSAyMzFjMTMuMzYtMTIuMTEgMTI5LjExNS0xMjcuODY1IDEyOS4xMTUtMTI3Ljg2NS0wLjA1Ny0xMi4yOCAwLjc0LTQyLjg2OCAwLjc0LTUxLjExMiAwLjA1Ni0yOC4yNTYtMzAuOTMtNTEuMzk2LTU5LjQ3LTUxLjM5NmgtNjUwLjI0QzU3LjcwNy0wLjA1NSAwLjExNCA0Ny4zMDQgMCAxMDIuOTA3bDAuMzk4IDgyMC44NmMxLjMwOCA1NS4zNzUgNDYuNjIgMTAwLjAwNiAxMDIuODQ5IDEwMC4wMDZoODI2LjQzYzU3LjAyNSAwIDEwMy4zMDQtNDUuODI1IDEwMy4zMDQtMTAyLjI4di01MS4xN2gwLjM0MWwtMC4yODQtMzA3LjU4YzAtNDkuOTc1LTIxLjQzNC03NC4xMzgtNTUuODMtNzQuMTM4eiBtODEuOTg0LTM2Ny43MzJjLTI4LjA4Ni0yNy44MDEtNzMuNTctMjcuODAxLTEwMS42NTUgMEwzNzYuMzc0IDY5OC44NTJjLTI4LjA4NiAyNy44MDEtMjguMDg2IDcyLjg4NyAwIDEwMC42ODggMjguMDg2IDI3LjgwMiA3My41NjkgMjcuODAyIDEwMS42NTUgMGw1ODEuMTYyLTU3OC4wMzVjMjguMDI5LTI3LjgwMiAyOC4wMjktNzIuODMgMC0xMDAuNjMyeiIgcC1pZD0iNTExNCIgZmlsbD0iIzAwQjE4NSIvPjwvc3ZnPg==
_describe CKEditor实现的本地存储编辑器

-- script --
function main({ cache, $, view, registry, open }) {
  view.mount();
}

-- view:html --
<script src="https://cdn.ckeditor.com/ckeditor5/38.0.0/classic/ckeditor.js"></script>
<div class="container">
    <!-- 左侧编辑器 -->
    <div class="editor-container">
        <div class="editor-content">
            <div id="editor"></div>
        </div>
        <div class="status-bar" id="statusBar">就绪（使用本地缓存）</div>
    </div>

    <!-- 右侧文件管理 -->
    <div class="sidebar">
        <div class="sidebar-controls">
            <button class="btn btn-primary" id="configBtn">配置</button>
            <button class="btn" id="createBtn">创建</button>
            <!-- 新增：本地模式按钮 -->
            <button class="btn" id="localModeBtn">本地模式</button>
        </div>
        <div class="file-tree" id="fileTree">
            <div class="loading">请先配置 GitHub 信息</div>
        </div>
    </div>
</div>

<!-- 配置模态框 -->
<div class="modal" id="configModal">
    <div class="modal-content">
        <div class="modal-header">GitHub 配置</div>

        <div class="clipboard-buttons">
            <button class="btn" id="pasteConfigBtn">从剪贴板『导入』配置</button>
            <button class="btn" id="copyConfigBtn">『导出』配置到剪贴板</button>
        </div>

        <div class="manual-input-section" style="display: none;">
            <div class="form-group">
                <label class="form-label">手动输入配置JSON（剪贴板读取失败）</label>
                <textarea class="config-textarea" id="manualConfigInput"
                    placeholder='示例：{"token":"ghp_xxx","owner":"用户名","repo":"仓库名","branch":"main"}'></textarea>
            </div>
            <button class="btn" id="parseManualConfigBtn">解析手动输入的配置</button>
        </div>

        <div class="form-group">
            <label class="form-label">GitHub Token</label>
            <input type="password" class="form-input" id="githubToken" placeholder="ghp_xxxxxxxxxxxx">
        </div>
        <div class="form-group">
            <label class="form-label">仓库所有者</label>
            <input type="text" class="form-input" id="repoOwner" placeholder="username">
        </div>
        <div class="form-group">
            <label class="form-label">仓库名称</label>
            <input type="text" class="form-input" id="repoName" placeholder="repository">
        </div>
        <div class="form-group">
            <label class="form-label">分支</label>
            <input type="text" class="form-input" id="branch" value="main">
        </div>
        <div class="modal-footer">
            <button class="btn" id="closeConfigBtn">取消</button>
            <button class="btn btn-primary" id="saveConfigBtn">保存</button>
        </div>
    </div>
</div>

<!-- 创建文件模态框 -->
<div class="modal" id="createModal">
    <div class="modal-content">
        <div class="modal-header">创建新文件</div>
        <div class="form-group">
            <label class="form-label">文件名</label>
            <input type="text" class="form-input" id="newFileName" placeholder="请输入文件名">
        </div>
        <div class="modal-footer">
            <button class="btn" id="closeCreateBtn">取消</button>
            <button class="btn btn-primary" id="confirmCreateBtn">创建</button>
        </div>
    </div>
</div>
-- view:css --
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box
}

body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif;
    height: 100vh;
    overflow: hidden
}

.container {
    display: flex;
    height: 100vh
}

.editor-container {
    flex: 2;
    display: flex;
    flex-direction: column
}

.sidebar {
    width: 250px;
    background: #f8f9fa;
    border-left: 1px solid #e1e4e8;
    display: flex;
    flex-direction: column
}

.sidebar-controls {
    padding: 16px;
    border-bottom: 1px solid #e1e4e8;
    display: flex;
    gap: 8px;
    justify-content: space-between;
}

.btn {
    padding: 6px 12px;
    border: 1px solid #d1d5da;
    border-radius: 6px;
    background: white;
    cursor: pointer;
    font-size: 14px;
    transition: .2s
}

.btn:hover {
    background: #f6f8fa;
    border-color: #0366d6
}

.btn-primary {
    background: #0366d6;
    color: white;
    border-color: #0366d6
}

.btn-primary:hover {
    background: #0256cc
}

.file-tree {
    flex: 1;
    overflow-y: auto;
    padding: 16px
}

.file-item {
    padding: 8px 12px;
    cursor: pointer;
    border-radius: 6px;
    margin-bottom: 4px;
    display: flex;
    align-items: center;
    gap: 8px;
    position: relative;
}

.delete-btn {
    display: none;
    position: absolute;
    right: 8px;
    color: #d73a49;
    background: none;
    border: none;
    cursor: pointer;
    padding: 4px 8px;
    border-radius: 4px;
}

.delete-btn:hover {
    background: #ffeef0;
}

.file-item:hover .delete-btn {
    display: block;
}

.file-item.active {
    background: #e1f0ff;
    color: #0366d6
}

.folder-icon::before {
    content: "📁"
}

.file-icon::before {
    content: "📄"
}

.editor-content {
    flex: 1;
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.editor-content .ck-editor {
    flex: 1;
    display: flex;
    flex-direction: column;
}

.editor-content .ck-editor__main {
    flex: 1;
    overflow: auto;
}

.editor-content .ck-editor__editable {
    min-height: 100%;
}

.status-bar {
    padding: 8px 16px;
    background: #f6f8fa;
    border-top: 1px solid #e1e4e8;
    font-size: 12px;
    color: #586069
}

.modal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, .5);
    z-index: 1000
}

.modal-content {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: white;
    padding: 24px;
    border-radius: 8px;
    width: 400px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, .15)
}

.modal-header {
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 16px
}

.form-group {
    margin-bottom: 16px
}

.form-label {
    display: block;
    margin-bottom: 4px;
    font-weight: 500
}

.form-input {
    width: 100%;
    padding: 8px 12px;
    border: 1px solid #d1d5da;
    border-radius: 6px;
    font-size: 14px
}

.config-textarea {
    width: 100%;
    min-height: 120px;
    padding: 8px 12px;
    border: 1px solid #d1d5da;
    border-radius: 6px;
    font-size: 14px;
    font-family: inherit;
    resize: vertical;
    white-space: pre;
    overflow-x: auto;
}

.clipboard-buttons {
    display: flex;
    gap: 8px;
    margin-bottom: 16px;
}

.manual-input-section {
    margin-top: 16px;
    padding-top: 16px;
    border-top: 1px dashed #e1e4e8;
}

.modal-footer {
    display: flex;
    justify-content: flex-end;
    gap: 8px;
    margin-top: 16px
}

.loading {
    text-align: center;
    padding: 20px;
    color: #586069
}

.error {
    color: #d73a49;
    background: #ffeef0;
    padding: 8px 12px;
    border-radius: 6px;
    margin: 8px 0
}

.success {
    color: #28a745;
    background: #f0fff4;
    padding: 8px 12px;
    border-radius: 6px;
    margin: 8px 0
}

-- view:js --
// 代替localStorage使用
const cache = window.MS_SCRIPT_ENV.cache;
console.log("脚本应用-加载js...")

/**
* GitHub 编辑器类 - 不依赖Octokit，使用原生Fetch API
* 新增：未选择文件时使用localStorage缓存编辑器内容
*/
class GitHubEditor {
    // 配置项
    #config = {
        token: '',
        owner: '',
        repo: '',
        branch: 'main'
    };

    // 状态变量
    #editor = null;          // CKEditor 实例
    #currentFile = null;     // 当前文件名
    #currentFilePath = null; // 当前文件路径
    #currentFileSha = null;  // 当前文件SHA
    #isContentChanged = false; // 内容是否修改
    #lastCreatedFileName = null; // 记录最后创建的文件名
    #LOCAL_STORAGE_KEY = 'editorLocalCache'; // 本地缓存键名

    // DOM 元素缓存
    #elements = {
        statusBar: document.getElementById('statusBar'),
        fileTree: document.getElementById('fileTree'),
        configModal: document.getElementById('configModal'),
        createModal: document.getElementById('createModal'),
        githubToken: document.getElementById('githubToken'),
        repoOwner: document.getElementById('repoOwner'),
        repoName: document.getElementById('repoName'),
        branch: document.getElementById('branch'),
        newFileName: document.getElementById('newFileName'),
        configBtn: document.getElementById('configBtn'),
        createBtn: document.getElementById('createBtn'),
        // 新增：本地模式按钮引用
        localModeBtn: document.getElementById('localModeBtn'),
        closeConfigBtn: document.getElementById('closeConfigBtn'),
        saveConfigBtn: document.getElementById('saveConfigBtn'),
        closeCreateBtn: document.getElementById('closeCreateBtn'),
        confirmCreateBtn: document.getElementById('confirmCreateBtn'),
        copyConfigBtn: document.getElementById('copyConfigBtn'),
        pasteConfigBtn: document.getElementById('pasteConfigBtn'),
        manualConfigInput: document.getElementById('manualConfigInput'),
        parseManualConfigBtn: document.getElementById('parseManualConfigBtn'),
        manualInputSection: document.querySelector('.manual-input-section')
    };

    constructor() {
        debugger

        // 初始化流程：事件监听 → 配置初始化 → 编辑器初始化 → 本地缓存加载
        this.#initEventListeners();
        this.#initSavedConfig();
        // 检查 ClassicEditor 对象是否存在
        function onClassicEditorLoadedLoaded(callback) {
            if (typeof ClassicEditor !== 'undefined') {
                callback(); // 如果 ClassicEditor 已经加载，执行回调
            } else {
                setTimeout(() => onClassicEditorLoadedLoaded(callback), 50);
            }
        }
        onClassicEditorLoadedLoaded(() => this.#initCKEditor());
    }

    /**
        * 初始化事件监听器
        */
    #initEventListeners() {
        // 模态框控制
        this.#elements.configBtn.addEventListener('click', () => this.showModal('config'));
        this.#elements.createBtn.addEventListener('click', () => this.showModal('create'));
        // 新增：本地模式按钮点击事件
        this.#elements.localModeBtn.addEventListener('click', () => this.switchToLocalMode());
        this.#elements.closeConfigBtn.addEventListener('click', () => this.hideModal('config'));
        this.#elements.closeCreateBtn.addEventListener('click', () => this.hideModal('create'));

        // 业务逻辑
        this.#elements.saveConfigBtn.addEventListener('click', () => this.saveConfig());
        this.#elements.confirmCreateBtn.addEventListener('click', () => this.createFile());
        this.#elements.copyConfigBtn.addEventListener('click', () => this.exportConfigToClipboard());
        this.#elements.pasteConfigBtn.addEventListener('click', () => this.importConfigFromClipboard());
        this.#elements.parseManualConfigBtn.addEventListener('click', () => this.parseManualConfig());

        // 全局事件
        document.addEventListener('visibilitychange', () => this.#handlePageVisibility());
        document.addEventListener('keydown', (e) => this.#handleKeyDown(e));
        window.addEventListener('click', (e) => this.#handleOutsideClick(e));
        window.addEventListener('beforeunload', (e) => this.#handleBeforeUnload(e));
    }

    /**
        * 切换到本地模式（初始状态）
        */
    async switchToLocalMode() {
        // 如果没有打开任何文件，无需切换
        if (!this.#currentFilePath) {
            this.updateStatus('已处于本地模式', 'info');
            return;
        }

        // 保存当前文件的更改（如果有的话）
        if (this.#isContentChanged) {
            const saveChanges = confirm('当前文件有未保存的更改，是否先保存？');
            if (saveChanges) {
                await this.#saveToGitHub();
            } else {
                // 用户选择不保存，询问是否放弃更改
                const discardChanges = confirm('确定要放弃当前文件的更改并切换到本地模式吗？');
                if (!discardChanges) return;
            }
        }

        // 重置当前文件状态
        this.#currentFile = null;
        this.#currentFilePath = null;
        this.#currentFileSha = null;
        this.#isContentChanged = false;
        
        // 取消文件高亮
        document.querySelectorAll('.file-item').forEach(item => {
            item.classList.remove('active');
        });
        
        // 加载本地缓存
        this.#loadLocalCache();
    }

    /**
        * 初始化本地存储的配置
        */
    #initSavedConfig() {
        const savedConfig = cache.get('githubConfig');
        if (savedConfig) {
            this.#config = JSON.parse(savedConfig);
            if (this.#config.token) {
                this.loadFileTree();
            }
        }
    }

    /**
        * 初始化 CKEditor
        */
    #initCKEditor() {
        ClassicEditor
            .create(document.querySelector('#editor'), {
                language: 'zh-cn',
                toolbar: [
                    'heading', '|',
                    'bold', 'italic', 'link', '|',
                    'bulletedList', 'numberedList', '|',
                    'blockQuote', 'codeBlock', '|',
                    'undo', 'redo'
                ],
                height: '100%'
            })
            .then(editor => {
                this.#editor = editor;
                // 加载本地缓存（仅当无当前文件时）
                this.#loadLocalCache();
                // 监听内容变化
                editor.model.document.on('change:data', () => this.#handleContentChange());
                // 监听焦点变化（失去焦点时保存）
                editor.ui.focusTracker.on('change:isFocused', (_, __, isFocused) => {
                    if (!isFocused && this.#isContentChanged) {
                        this.#saveContent();
                    }
                });
            })
            .catch(err => {
                console.error('CKEditor 初始化失败:', err);
                this.updateStatus('编辑器初始化失败', 'error');
            });
    }

    /**
        * 显示模态框
        */
    showModal(type) {
        if (type === 'create' && !this.#config.token) {
            this.updateStatus('请先配置 GitHub 信息', 'error');
            return;
        }

        if (type === 'config') {
            this.#elements.githubToken.value = this.#config.token || '';
            this.#elements.repoOwner.value = this.#config.owner || '';
            this.#elements.repoName.value = this.#config.repo || '';
            this.#elements.branch.value = this.#config.branch || 'main';
            this.#elements.manualInputSection.style.display = 'none';
            this.#elements.manualConfigInput.value = '';
        } else if (type === 'create') {
            this.#elements.newFileName.value = '';
            this.#elements.newFileName.focus();
        }

        this.#elements[`${type}Modal`].style.display = 'block';
    }

    /**
        * 隐藏模态框
        */
    hideModal(type) {
        this.#elements[`${type}Modal`].style.display = 'none';
    }

    /**
        * 更新状态栏信息
        */
    updateStatus(message, type = 'info') {
        const statusBar = this.#elements.statusBar;
        statusBar.textContent = message;

        const colorMap = {
            error: '#d73a49',
            success: '#28a745',
            info: '#586069'
        };
        statusBar.style.color = colorMap[type];

        setTimeout(() => {
            statusBar.style.color = colorMap.info;
        }, 3000);
    }

    /**
        * 保存 GitHub 配置
        */
    async saveConfig() {
        const token = this.#elements.githubToken.value.trim();
        const owner = this.#elements.repoOwner.value.trim();
        const repo = this.#elements.repoName.value.trim();
        const branch = this.#elements.branch.value.trim() || 'main';

        if (!token || !owner || !repo) {
            this.updateStatus('请填写完整的 GitHub 信息', 'error');
            return;
        }

        this.#config = { token, owner, repo, branch };
        cache.set('githubConfig', JSON.stringify(this.#config));

        this.hideModal('config');
        await this.loadFileTree();
        this.updateStatus('GitHub 配置已保存', 'success');
    }

    /**
        * 构建GitHub API请求头
        */
    #getHeaders() {
        return {
            'Authorization': `token ${this.#config.token}`,
            'Accept': 'application/vnd.github.v3+json',
            'Content-Type': 'application/json',
        };
    }

    /**
        * 处理API响应
        */
    async #handleResponse(response) {
        const data = await response.json();

        if (!response.ok) {
            const errorMessage = data.message || `HTTP错误: ${response.status}`;
            throw new Error(errorMessage);
        }

        return data;
    }

    /**
        * 加载文件树
        */
    async loadFileTree(path = '') {
        if (!this.#config.token) return;

        const fileTree = this.#elements.fileTree;
        fileTree.innerHTML = '<div class="loading">加载中...</div>';

        try {
            const url = `https://api.github.com/repos/${this.#config.owner}/${this.#config.repo}/contents/${path}?ref=${this.#config.branch}&time=${Date.now()}`;
            const response = await fetch(url, {
                method: 'GET',
                headers: this.#getHeaders()
            });

            const data = await this.#handleResponse(response);
            fileTree.innerHTML = '';
            this.#renderFileTree(data, fileTree, path);
        } catch (error) {
            fileTree.innerHTML = `<div class="error">加载失败：${error.message}</div>`;
            this.updateStatus('加载文件树失败', 'error');
        }
    }

    /**
        * 渲染文件树节点
        */
    #renderFileTree(items, container, parentPath) {
        const filteredItems = items
            .filter(item => item.type === 'dir' || item.name.endsWith('.md'))
            .sort((a, b) => {
                if (a.type === b.type) return a.name.localeCompare(b.name);
                return a.type === 'dir' ? -1 : 1;
            });

        filteredItems.forEach(item => {
            const itemElement = document.createElement('div');
            itemElement.className = 'file-item';
            itemElement.dataset.path = item.path;

            const pathDepth = parentPath ? parentPath.split('/').length + 1 : 1;
            itemElement.style.paddingLeft = `${16 * pathDepth}px`;

            if (item.type === 'dir') {
                itemElement.innerHTML = '<span class="folder-icon"></span>' + item.name;
                itemElement.addEventListener('click', () => this.#toggleFolder(item.path, itemElement));

                container.appendChild(itemElement);

                const childrenContainer = document.createElement('div');
                childrenContainer.className = 'folder-children';
                childrenContainer.style.display = 'none';
                container.appendChild(childrenContainer);
            } else {
                itemElement.innerHTML = `
        <span class="file-icon"></span>${item.name}
        <button class="delete-btn" title="删除文件">🗑️</button>
    `;

                itemElement.addEventListener('click', (e) => {
                    if (!e.target.classList.contains('delete-btn')) {
                        this.openFile(item.path, item.name, itemElement);
                    }
                });

                const deleteBtn = itemElement.querySelector('.delete-btn');
                deleteBtn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    this.#deleteFile(item.path, item.name);
                });

                container.appendChild(itemElement);

                if (this.#lastCreatedFileName && item.name === this.#lastCreatedFileName) {
                    this.#highlightActiveFile(itemElement);
                }
            }
        });
    }

    /**
        * 切换文件夹展开/折叠状态
        */
    async #toggleFolder(path, folderElement) {
        const childrenContainer = folderElement.nextElementSibling;

        if (childrenContainer.style.display === 'none') {
            childrenContainer.style.display = 'block';
            folderElement.style.background = '#f1f8ff';

            if (childrenContainer.innerHTML === '') {
                childrenContainer.innerHTML = '<div class="loading">加载中...</div>';
                try {
                    const url = `https://api.github.com/repos/${this.#config.owner}/${this.#config.repo}/contents/${path}?ref=${this.#config.branch}&time=${Date.now()}`;
                    const response = await fetch(url, {
                        method: 'GET',
                        headers: this.#getHeaders()
                    });

                    const data = await this.#handleResponse(response);
                    childrenContainer.innerHTML = '';
                    this.#renderFileTree(data, childrenContainer, path);
                } catch (error) {
                    childrenContainer.innerHTML = '<div class="error">加载失败</div>';
                }
            }
        } else {
            childrenContainer.style.display = 'none';
            folderElement.style.background = '';
        }
    }

    /**
        * 打开文件
        */
    async openFile(path, name, fileElement) {
        // 保存当前内容（可能是本地缓存或未保存的文件更改）
        if (this.#isContentChanged) {
            await this.#saveContent();
        }

        try {
            const url = `https://api.github.com/repos/${this.#config.owner}/${this.#config.repo}/contents/${path}?ref=${this.#config.branch}&time=${Date.now()}`;
            const response = await fetch(url, {
                method: 'GET',
                headers: this.#getHeaders()
            });

            const data = await this.#handleResponse(response);

            if (data.type === 'file' && data.content) {
                // 解码并设置文件内容
                const content = decodeURIComponent(escape(atob(data.content)));
                this.#editor.setData(content);

                // 更新文件状态
                this.#currentFile = name;
                this.#currentFilePath = path;
                this.#currentFileSha = data.sha;
                this.#isContentChanged = false;

                // 高亮文件 + 更新状态栏
                this.#highlightActiveFile(fileElement);
                this.updateStatus(`已打开 ${name}`);
            }
        } catch (error) {
            this.updateStatus(`打开文件失败：${error.message}`, 'error');
        }
    }

    /**
        * 高亮当前活动文件
        */
    #highlightActiveFile(activeElement) {
        document.querySelectorAll('.file-item').forEach(item => {
            item.classList.remove('active');
        });

        if (activeElement) {
            activeElement.classList.add('active');
            activeElement.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }
    }

    /**
        * 创建文件
        */
    async createFile() {
        let fileName = this.#elements.newFileName.value.trim();
        if (!fileName) {
            this.updateStatus('请输入文件名', 'error');
            return;
        }

        if (fileName.endsWith('.md')) {
            this.updateStatus('文件名无需输入 .md 后缀', 'error');
            return;
        }
        fileName += '.md';
        this.#lastCreatedFileName = fileName;

        try {
            const defaultContent = `# ${fileName.replace('.md', '')}\n\n开始编写...`;
            const encodedContent = btoa(unescape(encodeURIComponent(defaultContent)));

            const url = `https://api.github.com/repos/${this.#config.owner}/${this.#config.repo}/contents/${fileName}`;

            const response = await fetch(url, {
                method: 'PUT',
                headers: this.#getHeaders(),
                body: JSON.stringify({
                    message: `Create ${fileName}`,
                    content: encodedContent,
                    branch: this.#config.branch
                })
            });

            await this.#handleResponse(response);

            this.hideModal('create');
            await this.loadFileTree();

            setTimeout(() => {
                this.#openNewlyCreatedFile(fileName);
            }, 100);

            this.updateStatus(`文件 ${fileName} 创建成功`, 'success');
        } catch (error) {
            this.updateStatus(`创建文件失败：${error.message}`, 'error');
            this.#lastCreatedFileName = null;
        }
    }

    /**
        * 打开新创建的文件
        */
    #openNewlyCreatedFile(fileName) {
        if (!fileName) return;

        const fileItems = document.querySelectorAll('.file-item[data-path]');
        let targetItem = null;

        // 精确匹配路径
        fileItems.forEach(item => {
            if (item.dataset.path === fileName) {
                targetItem = item;
            }
        });

        // 文件名匹配
        if (!targetItem) {
            fileItems.forEach(item => {
                if (item.textContent.trim() === fileName && item.querySelector('.file-icon')) {
                    targetItem = item;
                }
            });
        }

        // 打开文件
        if (targetItem) {
            targetItem.click();
        } else {
            this.updateStatus(`未找到文件 ${fileName}，可能已被移动或删除`, 'info');
        }

        this.#lastCreatedFileName = null;
    }

    /**
        * 删除文件
        */
    async #deleteFile(path, name) {
        if (!confirm(`确定要删除文件 ${name} 吗？`)) return;

        try {
            // 获取文件最新SHA
            const getUrl = `https://api.github.com/repos/${this.#config.owner}/${this.#config.repo}/contents/${path}?ref=${this.#config.branch}&time=${Date.now()}`;
            const getResponse = await fetch(getUrl, {
                method: 'GET',
                headers: this.#getHeaders()
            });

            const fileData = await this.#handleResponse(getResponse);

            // 发送删除请求
            const deleteUrl = `https://api.github.com/repos/${this.#config.owner}/${this.#config.repo}/contents/${path}`;
            const deleteResponse = await fetch(deleteUrl, {
                method: 'DELETE',
                headers: this.#getHeaders(),
                body: JSON.stringify({
                    message: `Delete ${name}`,
                    sha: fileData.sha,
                    branch: this.#config.branch
                })
            });

            await this.#handleResponse(deleteResponse);

            // 如果删除当前文件：清空状态 + 加载本地缓存
            if (this.#currentFilePath === path) {
                this.#currentFile = null;
                this.#currentFilePath = null;
                this.#currentFileSha = null;
                this.#isContentChanged = false;
                this.#loadLocalCache(); // 恢复本地缓存内容
                this.updateStatus(`文件 ${name} 已删除，恢复本地缓存`, 'success');
            } else {
                this.updateStatus(`文件 ${name} 已删除`, 'success');
            }

            // 刷新文件树
            await this.loadFileTree();
        } catch (error) {
            this.updateStatus(`删除文件失败：${error.message}`, 'error');
        }
    }

    /**
        * 统一内容保存入口
        */
    async #saveContent() {
        // 已选择文件：保存到GitHub
        if (this.#currentFilePath) {
            await this.#saveToGitHub();
        }
        // 未选择文件：保存到localStorage
        else {
            this.#saveToLocalStorage();
        }
    }

    /**
        * 保存到GitHub
        */
    async #saveToGitHub() {
        try {
            const content = this.#editor.getData();
            const encodedContent = btoa(unescape(encodeURIComponent(content)));

            const url = `https://api.github.com/repos/${this.#config.owner}/${this.#config.repo}/contents/${this.#currentFilePath}`;

            const response = await fetch(url, {
                method: 'PUT',
                headers: this.#getHeaders(),
                body: JSON.stringify({
                    message: `Update ${this.#currentFile}`,
                    content: encodedContent,
                    sha: this.#currentFileSha,
                    branch: this.#config.branch
                })
            });

            const data = await this.#handleResponse(response);

            this.#currentFileSha = data.content.sha;
            this.#isContentChanged = false;
            this.updateStatus(`文件 ${this.#currentFile} 已保存`, 'success');
        } catch (error) {
            this.updateStatus(`保存文件失败：${error.message}`, 'error');
        }
    }

    /**
        * 保存到localStorage
        */
    #saveToLocalStorage() {
        const content = this.#editor.getData();
        cache.set(this.#LOCAL_STORAGE_KEY, content);
        this.#isContentChanged = false;
        this.updateStatus('本地缓存已更新', 'success');
    }

    /**
        * 从localStorage加载内容
        */
    #loadLocalCache() {
        if (this.#currentFilePath) return; // 已选择文件时不加载缓存

        //===> 版本更新兼容
        const oldKey = "ckeditor5StorageKey";
        const oldValue = cache.get(oldKey);
        if(oldValue != null) {
            cache.set(this.#LOCAL_STORAGE_KEY, oldValue)
            cache.remove(oldKey);
        }
        //<=== 版本更新兼容
        
        const cachedContent = cache.get(this.#LOCAL_STORAGE_KEY) || '';
        this.#editor.setData(cachedContent);
        this.updateStatus(cachedContent ? '已加载本地缓存' : '就绪（使用本地缓存）', 'info');
    }

    /**
        * 处理编辑器内容变化
        */
    #handleContentChange() {
        this.#isContentChanged = true;
        const statusMsg = this.#currentFilePath
            ? '内容已修改'
            : '内容已修改（未保存到本地缓存）';
        this.updateStatus(statusMsg, 'info');
    }

    /**
        * 处理页面可见性变化
        */
    #handlePageVisibility() {
        if (document.hidden && this.#isContentChanged) {
            this.#saveContent();
        }
    }

    /**
        * 处理键盘事件（Ctrl+S统一保存）
        */
    #handleKeyDown(e) {
        if (e.ctrlKey && e.key === 's') {
            e.preventDefault();
            this.#saveContent();
        }
    }

    /**
        * 处理窗口关闭事件
        */
    #handleBeforeUnload(e) {
        if (this.#isContentChanged) {
            // 保存本地缓存（同步执行，避免异步延迟）
            if (!this.#currentFilePath) {
                this.#saveToLocalStorage();
            }
            // 提示用户
            e.preventDefault();
            e.returnValue = '当前有未保存的更改，确定要离开吗？';
            return e.returnValue;
        }
    }

    /**
        * 处理模态框外部点击
        */
    #handleOutsideClick(e) {
        if (e.target.classList.contains('modal')) {
            e.target.style.display = 'none';
        }
    }

    /**
        * 工具方法：复制文本到剪贴板
        */
    async #copyToClipboard(text) {
        try {
            if (navigator.clipboard && window.isSecureContext) {
                await navigator.clipboard.writeText(text);
                return true;
            } else {
                const textarea = document.createElement('textarea');
                textarea.value = text;
                textarea.style.position = 'fixed';
                document.body.appendChild(textarea);
                textarea.select();
                document.execCommand('copy');
                document.body.removeChild(textarea);
                return true;
            }
        } catch (error) {
            console.error('剪贴板复制失败:', error);
            return false;
        }
    }

    /**
        * 导出配置到剪贴板
        */
    async exportConfigToClipboard() {
        try {
            const currentConfig = {
                token: this.#elements.githubToken.value.trim(),
                owner: this.#elements.repoOwner.value.trim(),
                repo: this.#elements.repoName.value.trim(),
                branch: this.#elements.branch.value.trim() || 'main'
            };

            if (!currentConfig.token && !currentConfig.owner && !currentConfig.repo) {
                this.updateStatus('配置为空，无需导出', 'info');
                return;
            }

            const configJson = JSON.stringify(currentConfig, null, 2);
            const copySuccess = await this.#copyToClipboard(configJson);

            if (copySuccess) {
                this.updateStatus('配置已复制到剪贴板', 'success');
            } else {
                this.updateStatus('剪贴板复制失败，请手动复制配置', 'error');
                this.#elements.manualConfigInput.value = configJson;
                this.#elements.manualInputSection.style.display = 'block';
            }
        } catch (error) {
            this.updateStatus(`配置导出失败：${error.message}`, 'error');
        }
    }

    /**
        * 从剪贴板导入配置
        */
    async importConfigFromClipboard() {
        try {
            let clipboardText = '';

            if (navigator.clipboard && window.isSecureContext) {
                clipboardText = await navigator.clipboard.readText();
            } else {
                throw new Error('浏览器不支持直接读取剪贴板，请手动粘贴');
            }

            await this.#parseConfigText(clipboardText);
        } catch (error) {
            this.updateStatus(`剪贴板读取失败：${error.message}`, 'error');
            this.#elements.manualInputSection.style.display = 'block';
            this.#elements.manualConfigInput.focus();
        }
    }

    /**
        * 解析手动输入的配置文本
        */
    async parseManualConfig() {
        try {
            const configText = this.#elements.manualConfigInput.value.trim();
            if (!configText) {
                this.updateStatus('请输入配置JSON文本', 'error');
                return;
            }

            await this.#parseConfigText(configText);
        } catch (error) {
            this.updateStatus(`配置解析失败：${error.message}`, 'error');
        }
    }

    /**
        * 统一解析配置文本
        */
    async #parseConfigText(configText) {
        try {
            const importedConfig = JSON.parse(configText);
            const requiredKeys = ['token', 'owner', 'repo', 'branch'];
            const missingKeys = requiredKeys.filter(key => !importedConfig.hasOwnProperty(key));

            if (missingKeys.length > 0) {
                throw new Error(`缺少必要字段：${missingKeys.join(', ')}`);
            }

            this.#elements.githubToken.value = importedConfig.token || '';
            this.#elements.repoOwner.value = importedConfig.owner || '';
            this.#elements.repoName.value = importedConfig.repo || '';
            this.#elements.branch.value = importedConfig.branch || 'main';

            this.#elements.manualInputSection.style.display = 'none';
            this.updateStatus('配置导入成功，请保存', 'success');
        } catch (error) {
            throw error;
        }
    }

    /**
        * 销毁方法
        */
    destroy() {
        if (this.#editor) {
            this.#editor.destroy();
        }

        document.removeEventListener('visibilitychange', () => this.#handlePageVisibility());
        document.removeEventListener('keydown', (e) => this.#handleKeyDown(e));
        window.removeEventListener('click', (e) => this.#handleOutsideClick(e));
        window.removeEventListener('beforeunload', (e) => this.#handleBeforeUnload(e));
        this.#elements.copyConfigBtn.removeEventListener('click', () => this.exportConfigToClipboard());
        this.#elements.pasteConfigBtn.removeEventListener('click', () => this.importConfigFromClipboard());
        this.#elements.parseManualConfigBtn.removeEventListener('click', () => this.parseManualConfig());
    }
}
const app = new GitHubEditor();