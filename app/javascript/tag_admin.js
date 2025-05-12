document.addEventListener("turbo:load", () => {
  // タグ管理モーダルの開閉
  const adminModal = document.getElementById("tag-admin-modal");
  const openAdminBtn = document.getElementById("open-tag-admin");
  const closeAdminBtn = document.getElementById("close-tag-admin");

  openAdminBtn?.addEventListener("click", () => {
    adminModal.style.display = "flex";
  });

  closeAdminBtn?.addEventListener("click", () => {
    adminModal.style.display = "none";
  });

  // 全角→半角変換（英数字・記号）
  function normalizeToHalfWidth(str) {
    return str
      .replace(/[Ａ-Ｚａ-ｚ０-９！＠＃＄％＆（）ー－＝＋：；？’”“［］｛｝＜＞／＼]/g, (s) =>
        String.fromCharCode(s.charCodeAt(0) - 0xFEE0)
      );
  }

  // タグ検索フィルター
  const input = document.getElementById("tag-admin-search");
  if (input) {
    input.addEventListener("input", () => {
      const keyword = input.value.toLowerCase();
      document.querySelectorAll(".tag-admin-item").forEach((item) => {
        const name = item.dataset.name.toLowerCase();
        item.style.display = name.includes(keyword) ? "block" : "none";
      });
    });
  }

  // タグのリネーム処理
  document.querySelectorAll(".rename-tag-btn").forEach((btn) => {
    btn.addEventListener("click", () => {
      const id = btn.dataset.id;
      const oldName = btn.dataset.name;
      let newName = prompt("新しいタグ名を入力:", oldName);
      if (!newName || newName === oldName) return;

      newName = normalizeToHalfWidth(newName); // ← ここで半角化

      fetch("/tags/rename", {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
        },
        body: JSON.stringify({ id, new_name: newName }),
      }).then((res) => {
        if (res.ok) {
          location.reload();
        } else {
          alert("タグの変更に失敗しました");
        }
      });
    });
  });

  // タグの削除処理
  document.querySelectorAll(".delete-tag-btn").forEach((btn) => {
    btn.addEventListener("click", () => {
      if (!confirm("本当にこのタグを削除しますか？")) return;

      fetch(`/tags/${btn.dataset.id}`, {
        method: "DELETE",
        headers: {
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
        },
      }).then((res) => {
        if (res.ok) {
          location.reload();
        } else {
          alert("タグの削除に失敗しました");
        }
      });
    });
  });
});
