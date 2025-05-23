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

  // 全角→半角変換（英数字）
  function normalizeToHalfWidth(str) {
  return str.replace(/[Ａ-Ｚａ-ｚ０-９]/g, (s) =>
    String.fromCharCode(s.charCodeAt(0) - 0xFEE0)
  );
 }

  // タグ検索フィルター
  const input = document.getElementById("tag-admin-search");
  if (input) {
    input.addEventListener("input", () => {
      const keyword = normalizeToHalfWidth(input.value.toLowerCase());
      document.querySelectorAll(".tag-admin-item").forEach((item) => {
        const name = normalizeToHalfWidth(item.dataset.name.toLowerCase());
        item.style.display = name.includes(keyword) ? "block" : "none";
      });
    });
  }

  // リネーム処理（2段階確認）
  let currentRenameTagId = null;
  let newTagName = "";
  const renameWarningModal = document.getElementById("tag-rename-warning-modal");
  const renameConfirmModal = document.getElementById("tag-rename-confirm-modal");

  document.querySelectorAll(".rename-tag-btn").forEach((btn) => {
    btn.addEventListener("click", () => {
      currentRenameTagId = btn.dataset.id;
      const oldName = btn.dataset.name;
      newTagName = "";
      document.getElementById("tag-rename-warning-message").innerHTML = `<strong>${oldName}</strong> を変更すると、このタグが付いたすべての投稿が一括で変更されます。`;
      document.getElementById("tag-rename-input").value = oldName;
      renameWarningModal.style.display = "flex";
    });
  });

  document.getElementById("cancel-tag-rename")?.addEventListener("click", () => {
    renameWarningModal.style.display = "none";
    currentRenameTagId = null;
  });

  document.getElementById("proceed-to-rename-confirm")?.addEventListener("click", () => {
    newTagName = normalizeToHalfWidth(document.getElementById("tag-rename-input").value.trim());
    if (!newTagName || !currentRenameTagId) return;
    renameWarningModal.style.display = "none";
    renameConfirmModal.style.display = "flex";
  });

  document.getElementById("confirm-tag-rename-no")?.addEventListener("click", () => {
    renameConfirmModal.style.display = "none";
    currentRenameTagId = null;
    newTagName = "";
  });

  document.getElementById("confirm-tag-rename-yes")?.addEventListener("click", () => {
    if (!newTagName || !currentRenameTagId) return;
    fetch("/tags/rename", {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
      },
      body: JSON.stringify({ id: currentRenameTagId, new_name: newTagName }),
    }).then((res) => {
      if (res.ok) {
        location.reload();
      } else {
        alert("タグの変更に失敗しました");
      }
    });
  });

  // 削除処理（2段階確認）
  let currentTagId = null;
  const warningModal = document.getElementById("tag-delete-warning-modal");
  const confirmModal = document.getElementById("tag-delete-confirm-modal");
  const warningMessage = document.getElementById("tag-warning-message");
  const proceedBtn = document.getElementById("proceed-to-confirm");
  const cancelWarningBtn = document.getElementById("cancel-tag-warning");
  const confirmYes = document.getElementById("confirm-tag-delete-yes");
  const confirmNo = document.getElementById("confirm-tag-delete-no");

  document.querySelectorAll(".delete-tag-btn").forEach((btn) => {
    btn.addEventListener("click", () => {
      currentTagId = btn.dataset.id;
      const tagName = btn.closest(".tag-admin-item").querySelector(".tag-name-link")?.textContent || "このタグ";
      warningMessage.innerHTML = `<strong>${tagName}</strong> を削除すると、すべての画像からこのタグが外れます。`;
      warningModal.style.display = "flex";
    });
  });

  cancelWarningBtn?.addEventListener("click", () => {
    warningModal.style.display = "none";
    currentTagId = null;
  });

  proceedBtn?.addEventListener("click", () => {
    warningModal.style.display = "none";
    confirmModal.style.display = "flex";
  });

  confirmNo?.addEventListener("click", () => {
    confirmModal.style.display = "none";
    currentTagId = null;
  });

  confirmYes?.addEventListener("click", () => {
    if (!currentTagId) return;
    fetch(`/tags/${currentTagId}`, {
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
