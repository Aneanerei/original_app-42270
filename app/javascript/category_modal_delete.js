let currentCategoryForm = null;

document.addEventListener("turbo:load", () => {
  window.confirmCategoryDelete = (button) => {
    currentCategoryForm = button.closest("form");

    const select = currentCategoryForm.querySelector("select[name='category_id']");
    const selectedOption = select.options[select.selectedIndex];

    // カテゴリが未選択なら処理を中断
    if (!select.value) {
      alert("カテゴリを選択してください");
      return;
    }

    // カテゴリ名をモーダルに挿入
    const nameSpan = document.getElementById("categoryNameToDelete");
    if (nameSpan) {
      nameSpan.textContent = selectedOption.text;
    }

    // モーダル表示
    document.getElementById("customDeleteModal").style.display = "flex";
  };

  window.closeCategoryDeleteModal = () => {
    document.getElementById("customDeleteModal").style.display = "none";
    currentCategoryForm = null;
  };

  window.submitCategoryDeleteForm = () => {
    if (currentCategoryForm) currentCategoryForm.submit();
  };
});
