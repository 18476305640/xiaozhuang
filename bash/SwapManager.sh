#!/bin/bash
# swap_manager.sh - 统一管理 /swapfile/ 目录下的 swap 文件，自动编号，交互菜单

if [[ $EUID -ne 0 ]]; then
    echo "❌ 请使用 root 用户运行该脚本"
    exit 1
fi

SWAP_DIR="/swapfile"

# 检查 swap 目录是否合法
check_swap_dir() {
    if [[ -e "$SWAP_DIR" && ! -d "$SWAP_DIR" ]]; then
        echo "❌ 错误：$SWAP_DIR 已存在但不是目录"
        echo "   请先删除该文件：rm -f $SWAP_DIR"
        exit 1
    fi
    
    # 确保目录存在
    mkdir -p "$SWAP_DIR" || {
        echo "❌ 无法创建目录 $SWAP_DIR"
        exit 1
    }
}

add_swap() {
    check_swap_dir  # 确保目录合法
    
    read -p "请输入 swap 大小(MB): " size_mb
    if [[ -z "$size_mb" || ! "$size_mb" =~ ^[0-9]+$ || "$size_mb" -le 0 ]]; then
        echo "❌ 请输入有效的正整数大小"
        return
    fi

    # 找到第一个不存在的 swapfile-N 文件名
    idx=0
    while [[ -f "$SWAP_DIR/swapfile-$idx" ]]; do
        ((idx++))
    done
    file_path="$SWAP_DIR/swapfile-$idx"

    echo "➡ 创建 swap 文件: $file_path (${size_mb}MB)"
    if dd if=/dev/zero of="$file_path" bs=1M count="$size_mb" status=progress; then
        chmod 600 "$file_path"
        mkswap "$file_path"
        swapon "$file_path"

        if ! grep -q "$file_path" /etc/fstab; then
            echo "$file_path none swap sw 0 0" >> /etc/fstab
        fi

        echo "✅ 已添加 swap 文件: $file_path (${size_mb}MB)"
    else
        echo "❌ 创建 swap 文件失败"
        # 清理可能创建了一半的文件
        rm -f "$file_path"
    fi
}

del_swap() {
    # 列出 /swapfile/ 下所有已启用的 swap 文件
    mapfile -t swap_list < <(swapon --show=NAME --noheadings | grep "^$SWAP_DIR/swapfile-")

    if [[ ${#swap_list[@]} -eq 0 ]]; then
        echo "⚠ 没有已启用的 /swapfile/ 下的 swap 文件"
        return
    fi

    echo "📄 当前已启用的 swap 文件:"
    for i in "${!swap_list[@]}"; do
        echo "$((i+1))) ${swap_list[$i]}"
    done

    read -p "请输入要删除的编号: " idx
    if ! [[ "$idx" =~ ^[0-9]+$ ]] || (( idx < 1 || idx > ${#swap_list[@]} )); then
        echo "❌ 无效编号"
        return
    fi

    file_path="${swap_list[$((idx-1))]}"
    echo "➡ 正在删除 swap 文件: $file_path"

    swapoff "$file_path" 2>/dev/null
    sed -i "\|$file_path|d" /etc/fstab
    if [[ -f "$file_path" ]]; then
        rm -f "$file_path"
        echo "🗑 已删除 swap 文件: $file_path"
    else
        echo "⚠ 文件不存在: $file_path"
    fi
    echo "✅ 删除完成"
}

list_swap() {
    echo "📄 当前 swap 情况:"
    swapon --show
    free -h | grep Swap
}

# 启动时先检查目录合法性
check_swap_dir

while true; do
    echo ""
    echo "====== Swap 管理 (统一路径: $SWAP_DIR) ======"
    echo "1) 添加 Swap"
    echo "2) 删除 Swap"
    echo "3) 查询 Swap"
    echo "4) 退出"
    read -p "请选择操作(1-4): " choice
    case "$choice" in
        1) add_swap ;;
        2) del_swap ;;
        3) list_swap ;;
        4) echo "👋 已退出"; exit 0 ;;
        *) echo "❌ 无效选项" ;;
    esac
done