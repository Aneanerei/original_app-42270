let currentWorkCategoryForm = null;

document.addEventListener("turbo:load", () => {
  // 削除確認表示
  window.confirmWorkCategoryDelete = (button) => {
    currentWorkCategoryForm = button.closest("form");
    const select = currentWorkCategoryForm.querySelector("select");
    const selectedOption = select.options[select.selectedIndex];

    if (!select.value) {
      alert("削除するカテゴリを選択してください。");
      return;
    }

    const categoryName = selectedOption?.text || "カテゴリ";
    document.getElementById("delete-work-category-name").textContent = categoryName;
    document.getElementById("customWorkCategoryDeleteModal").style.display = "flex";
  };

  // モーダルを閉じる
  window.closeWorkCategoryDeleteModal = () => {
    document.getElementById("customWorkCategoryDeleteModal").style.display = "none";
    currentWorkCategoryForm = null;
  };

  // 実際にフォームを送信
  window.submitWorkCategoryDeleteForm = () => {
    if (currentWorkCategoryForm) {
      currentWorkCategoryForm.submit();
    }
  };
});